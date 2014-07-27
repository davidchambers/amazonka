{-# LANGUAGE MultiWayIf        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE ViewPatterns      #-}

-- Module      : Generator.Transform
-- Copyright   : (c) 2013-2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Generator.Transform where

import           Control.Arrow
import           Control.Lens
import           Control.Monad
import           Control.Monad.State
import           Data.Char
import           Data.Default
import           Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as Map
import           Data.HashSet        (HashSet)
import qualified Data.HashSet        as Set
import           Data.List
import           Data.Maybe
import           Data.Monoid         hiding (Sum)
import           Data.Ord
import           Data.String
import           Data.Text           (Text)
import qualified Data.Text           as Text
import           Generator.AST
import           Text.EDE.Filters

-- FIXME: Make a way to override the endpoint when sending a request (for mocks etc)
-- FIXME: Provide the 'length' of the prefix so lenses can be derived.
-- FIXME: Fix ambiguous lens fields
-- FIXME: Add documentation about where the type in the 'Types' module is used
-- FIXME: Add selected de/serialisation tests for the services
-- FIXME: Rewrite, so that each transformation step happens goddamn logically.


-- FIXME: Why is NextToken from EC2 DescribeTags not marked as required
-- This is a continuation of response type fields all being 'Maybe'
-- how should it be solved?


transform :: [Service] -> [Service]
transform = map eval . sort . nub
  where
    eval s = s
        & svcOperations .~ evalState (mapM (operation s) (_svcOperations s)) mempty

current :: [Service] -> [Service]
current = mapMaybe latest . groupBy identical
  where
    identical x y = EQ == comparing _svcName x y

    latest [] = Nothing
    latest xs = Just . head $ sortBy (comparing _svcVersion) xs

operation :: Service -> Operation -> State (HashSet Text) Operation
operation svc@Service{..} o = do
    rq <- uniquify svc (o ^. opRequest  . rqShape)
    rs <- uniquify svc (o ^. opResponse . rsShape)

    let x = o & opService          .~ _svcName
              & opNamespace        .~ _svcVersionNamespace <> NS [_opName o]
              & opTypesNamespace   .~ _svcTypesNamespace
              & opVersionNamespace .~ _svcVersionNamespace
              & opRequestNamespace .~ "Network.AWS.Request" <> fromString (show _svcType)

        y = x & opRequest  . rqShape .~ rq
              & opRequest            %~ request svc x
              & opResponse . rsShape .~ rs
              & opResponse           %~ response svc x

        z = y & opPagination %~ fmap (pagination y)

    return z

uniquify :: Service -> Shape -> State (HashSet Text) Shape
uniquify svc (special svc -> s) = do
    x <- go (s ^. cmnPrefix) (s ^. cmnName)
    case s of
        SStruct c@Struct{..} -> do
            xs <- mapM (uniquify svc) (Map.elems _sctFields)
            let fs = Map.fromList (zip (Map.keys _sctFields) xs)
            return . SStruct $ (c & cmnPrefix .~ x) { _sctFields = fs }
        SList l@List{..} -> do
            i <- uniquify svc _lstItem
            return . SList $ (l & cmnPrefix .~ x) { _lstItem = i }
        SMap m@Map{..} -> do
            k <- uniquify svc _mapKey
            v <- uniquify svc _mapValue
            return . SMap $ (m & cmnPrefix .~ x) { _mapKey = k, _mapValue = v }
        _ -> return s
  where
    go :: Text -> Text -> State (HashSet Text) Text
    go x n = do
        p <- gets (Set.member x)
        if p
            then go (next x n) n
            else modify (Set.insert x) >> return x

    next x n
        | Text.null x = "_a"
        | "_" <- x    = "_a"
        | otherwise   = Text.init x <> succ' n (Text.last x)

    succ' n 'z' = Text.toLower (Text.pack [Text.head n, Text.last n])
    succ' _ c   = Text.singleton (succ c)

special :: Service -> Shape -> Shape
special svc s = f (_svcName svc) (s ^. cmnName) s
  where
    -- Special cases for erroneous service model types
    f "EC2" "String" = cmnName .~ "VirtualizationType"
    f _     _        = id

request :: Service -> Operation -> Request -> Request
request svc o rq = rq
    & rqName     .~ (o ^. opName)
    & rqDefault  .~ lowerFirst (o ^. opName)
    & rqHttp     %~ http (rq ^. rqShape)
    & rqFields   .~ fs
    & rqPayload  .~ bdy
    & rqRequired .~ req
    & rqHeaders  .~ hs
  where
    bdy = listToMaybe $ filter ((== LBody) . view cmnLocation) fs
    req = filter (view cmnRequired) fs
    hs  = filter ((== LHeader) . view cmnLocation) fs

    fs  = map upd . sort . fields True svc $ rq ^. rqShape

    upd f | f ^. cmnLocation == LBody = f & cmnRequired .~ True
          | otherwise                 = f

http :: Shape -> HTTP -> HTTP
http p = hPath %~ map f
  where
    f (PVar v) = PVar (prefixed p v)
    f c        = c

response :: Service -> Operation -> Response -> Response
response svc o rs = rs
    & rsName    .~ (o ^. opName) <> "Response"
    & rsFields  .~ fs
    & rsPayload .~ bdy
    & rsHeaders .~ hs
    & rsType    .~ typ
  where
    bdy = listToMaybe $ filter ((== LBody) . view cmnLocation) fs
    hs  = filter ((== LHeader) . view cmnLocation) fs

    fs  = sort . fields False svc $ rs ^. rsShape

    typ | maybe False (view cmnStreaming) bdy    = RBody
        | length hs == length fs                 = RHeaders
        | all ((== LBody) . view cmnLocation) fs = RXml
        | otherwise                              = def

pagination :: Operation -> Pagination -> Pagination
pagination o p =
    case p of
        More m  ts -> More (rsPref m)  (map token ts)
        Next rk t  -> Next (rsPref rk) (token t)
  where
    token t = t & tokInput %~ rqPref & tokOutput %~ replace

    -- S3 ListObjects
    replace "NextMarker || Contents[-1].Key" =
        "fmap (toText . _oKey) . listToMaybe $ _looContents"
    replace x = rsPref x

    rqPref = pref (opRequest  . rqShape)
    rsPref = pref (opResponse . rsShape)

    pref s = prefixed (o ^. s)

rootNS :: NS -> NS
rootNS (NS []) = NS []
rootNS (NS xs) = NS (init xs)

typeNS :: NS -> NS
typeNS = (<> "Types")

lensNS :: NS -> NS
lensNS = (<> "Lenses")

serviceNamespaces :: Service -> [NS]
serviceNamespaces s = sort
    $ _svcTypesNamespace s
    : _svcLensNamespace s
    : map _opNamespace (_svcOperations s)

shapeEnums :: Text -> [Text] -> HashMap Text Text
shapeEnums n = Map.fromList . map trans . filter (not . Text.null)
  where
    trans = first (mappend (reserve n) . rules) . join (,)

    reserve x
        | x `elem` unprefixed = ""
        | otherwise           = x

    unprefixed =
        [ "InstanceType"
        ]

    rules x =
        let y  = Text.replace ":" ""
               . Text.replace "." " "
               . Text.replace "/" " "
               . Text.replace "(" " "
               . Text.replace ")" " "
               . Text.replace "_" " "
               $ Text.replace "-" " " x
            zs = Text.words y

         in if | length zs > 1      -> Text.concat (map Text.toTitle zs)
               | Text.all isUpper y -> Text.toTitle y
               | otherwise          -> upcase y

    upcase x
        | Text.null x = x
        | otherwise   = toUpper (Text.head x) `Text.cons` Text.tail x

fields :: Bool -> Service -> Shape -> [Field]
fields rq svc s = case s of
    SStruct Struct{..} -> map f (Map.toList _sctFields)
    _                  -> []
  where
    f :: (Text, Shape) -> Field
    f (k, v) =
        let fld = Field (typeof rq svc v) (prefixed s k) (v ^. common)
         in if k == "IsTruncated"
                then fld & cmnRequired .~ True & fldType %~ (anRequired_ .~ True)
                else fld

prefixed :: Shape -> Text -> Text
prefixed p = mappend (p ^. cmnPrefix)

shapeType :: Bool -> Service -> Shape -> Type
shapeType rq svc s = Type s (typeof rq svc s) (ctorof s) (fields rq svc s)

typeof :: Bool -> Service -> Shape -> Ann
typeof rq svc s = Ann req (defaults s) (monoids s) typ
  where
    typ = case s of
        SStruct Struct {}       -> n
        SList   List   {..}     -> "[" <> ann _lstItem <> "]"
        SMap    Map    {..}     -> "HashMap " <> ann _mapKey <> " " <> ann _mapValue
        SSum    Sum    {}
            | swt, req          -> "Switch " <> n
            | swt               -> "(Switch " <> n <> ")"
            | otherwise         -> n
        SPrim   Prim   {..}
            | n `elem` reserved -> n
            | n == "Delimiter"
            , _prmType == PText -> "Char"
            | bdy, rq           -> "RqBody"
            | bdy               -> "RsBody"
            | otherwise         -> fmt _prmType

    n   = s ^. cmnName
    ann = _anType . typeof rq svc

    req = bdy || s ^. cmnRequired
    swt = n `elem` switches
    bdy = body s

    fmt x = Text.pack $
        case x of
            PUTCTime -> show (_svcTimestamp svc)
            _        -> drop 1 (show x)

-- required :: Bool -> Shape -> Bool
-- --required True s = s ^. cmnLocation == LBody || s ^. cmnRequired
-- required _    s = s ^. cmnRequired

body :: Shape -> Bool
body s = s ^. cmnLocation == LBody && s ^. cmnStreaming

reserved :: [Text]
reserved =
    [ "BucketName"
    , "ObjectKey"
    , "ObjectVersionId"
    , "ETag"
    , "Region"
    , "AvailabilityZone"
    ]

switches :: [Text]
switches =
    [ "BucketVersioningStatus"
    , "ExpirationStatus"
    , "MFADelete"
    , "MFADeleteStatus"
    ]

ctorof :: Shape -> Ctor
ctorof s =
    case s of
        SStruct Struct{..}
            | Map.size _sctFields == 1   -> CNewtype
            | Map.null _sctFields        -> CNullary
        SSum{}
            | (s ^. cmnName) `elem` switches -> CSwitch
            | otherwise                  -> CSum
        _                                -> CData

defaults :: Shape -> Bool
defaults s =
    case s of
        SStruct {} -> False
        SList   l  -> _lstMinLength l < 1
        SMap    {} -> False
        SSum    {} -> False
        SPrim   {} -> False

monoids :: Shape -> Bool
monoids s =
    case s of
        SStruct {} -> False
        SList   l  -> _lstMinLength l < 1
        SMap    {} -> True
        SSum    {} -> False
        SPrim   {} -> False

setDirection :: Direction -> Shape -> Shape
setDirection d s =
    case s of
        SStruct x@Struct{..} ->
            SStruct (dir x { _sctFields = Map.map (setDirection d) _sctFields })
        SList x@List{..} ->
            SList (dir x { _lstItem = dir _lstItem })
        SMap x@Map{..} ->
            SMap (dir x { _mapKey = dir _mapKey, _mapValue = dir _mapValue })
        SSum x ->
            SSum (dir x)
        SPrim x ->
            SPrim (dir x)
  where
    dir :: HasCommon a => a -> a
    dir = cmnDirection .~ d

serviceTypes :: Service -> [Type]
serviceTypes svc@Service{..} = sort
    . Map.elems
    . (`execState` mempty)
    . mapM uniq
    . map (shapeType True svc . snd)
    . concatMap opfields
    $ _svcOperations
  where
    uniq :: Type -> State (HashMap Text Type) ()
    uniq x = modify $ \m ->
        let n = x ^. cmnName
            y = Map.lookup n m
            z = maybe x (cmnDirection <>~ (x ^. cmnDirection)) y
         in Map.insert n z m

    opfields o =
           descend (_rqShape $ _opRequest  o)
        ++ descend (_rsShape $ _opResponse o)

    descend (SStruct Struct{..}) = concatMap (uncurry flat) (Map.toList _sctFields)
    descend _                    = []

    flat p s@SStruct {}         = (p, s) : descend s
    flat _ s@(SList  List {..}) = flat ((s ^. cmnName)) _lstItem
    flat _ s@(SMap   Map  {..}) = flat ((s ^. cmnName)) _mapKey ++ flat ((s ^. cmnName)) _mapValue
    flat p (SSum     x)         = [(p, SSum $ rename x)]
    flat _ _                    = []

    rename s
        | (s ^. cmnName) `notElem` switches = s
        | otherwise = s { _sumValues        = f (_sumValues s) }
      where
        f = Map.fromList . map g . Map.toList

        g (_, "Enabled") = ("Enabled", "Enabled")
        g (_, v)         = ("Disabled", v)

serviceError :: Abbrev -> [Operation] -> Error
serviceError a os = Error (unAbbrev a <> "Error") ss ts
  where
    ts = Map.fromList $ map (\s -> (s ^. cmnName, shapeType True svc s)) ss

    ss = except "Serializer" "String"
       : except "Client" "HttpException"
       : except "Service" "String"
       : nub (concatMap _opErrors os)

    except s t = SStruct $ Struct (Map.fromList [("", field)]) ctor
      where
        field = SStruct . Struct mempty $ def & cmnName .~ t & cmnRequired .~ True
        ctor  = def & cmnName .~ (unAbbrev a <> s)

    svc = Service
        { _svcName             = a
        , _svcFullName         = unAbbrev a
        , _svcNamespace        = def
        , _svcVersionNamespace = def
        , _svcTypesNamespace   = def
        , _svcLensNamespace    = def
        , _svcVersion          = Version mempty
        , _svcRawVersion       = mempty
        , _svcType             = def
        , _svcError            = Error (unAbbrev a) [] mempty
        , _svcWrapped          = False
        , _svcSignature        = def
        , _svcDocumentation    = def
        , _svcEndpointPrefix   = mempty
        , _svcGlobalEndpoint   = def
        , _svcXmlNamespace     = def
        , _svcTimestamp        = def
        , _svcChecksum         = def
        , _svcJsonVersion      = def
        , _svcTargetPrefix     = def
        , _svcOperations       = []
        }
