{-# LANGUAGE DeriveGeneric               #-}
{-# LANGUAGE FlexibleInstances           #-}
{-# LANGUAGE OverloadedStrings           #-}
{-# LANGUAGE RecordWildCards             #-}
{-# LANGUAGE TypeFamilies                #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Module      : Network.AWS.EC2.V2014_05_01.CreateRouteTable
-- Copyright   : (c) 2013-2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

-- | Creates a route table for the specified VPC. After you create a route
-- table, you can add routes and associate the table with a subnet. For more
-- information about route tables, see Route Tables in the Amazon Virtual
-- Private Cloud User Guide. Example This example creates a route table for
-- the VPC with the ID vpc-11ad4878. By default, every route table includes a
-- local route that enables traffic to flow within the VPC. The following
-- response shows that route.
-- https://ec2.amazonaws.com/?Action=CreateRouteTable &amp;VpcId=vpc-11ad4878
-- &amp;AUTHPARAMS 59dbff89-35bd-4eac-99ed-be587EXAMPLE rtb-f9ad4890
-- vpc-11ad4878 10.0.0.0/22 local active.
module Network.AWS.EC2.V2014_05_01.CreateRouteTable where

import           Control.Applicative
import           Data.ByteString      (ByteString)
import           Data.Default
import           Data.HashMap.Strict  (HashMap)
import           Data.Maybe
import           Data.Monoid
import           Data.Text            (Text)
import qualified Data.Text            as Text
import           GHC.Generics
import           Network.AWS.Data
import           Network.AWS.Response
import           Network.AWS.Types    hiding (Region, Error)
import           Network.AWS.Request.Query
import           Network.AWS.EC2.V2014_05_01.Types
import           Network.HTTP.Client  (RequestBody, Response)
import           Prelude              hiding (head)

data CreateRouteTable = CreateRouteTable
    { _crtrVpcId :: Text
      -- ^ The ID of the VPC.
    , _crtrDryRun :: Maybe Bool
      -- ^ 
    } deriving (Generic)

instance ToQuery CreateRouteTable where
    toQuery = genericToQuery def

instance AWSRequest CreateRouteTable where
    type Sv CreateRouteTable = EC2
    type Rs CreateRouteTable = CreateRouteTableResponse

    request = post "CreateRouteTable"
    response _ = xmlResponse

data CreateRouteTableResponse = CreateRouteTableResponse
    { _crtsRouteTable :: Maybe RouteTable
      -- ^ Information about the route table.
    } deriving (Generic)

instance FromXML CreateRouteTableResponse where
    fromXMLOptions = xmlOptions
