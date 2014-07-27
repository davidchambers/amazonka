{-# LANGUAGE DeriveGeneric               #-}
{-# LANGUAGE FlexibleInstances           #-}
{-# LANGUAGE OverloadedStrings           #-}
{-# LANGUAGE RecordWildCards             #-}
{-# LANGUAGE TypeFamilies                #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Module      : Network.AWS.EC2.V2014_05_01.ReplaceNetworkAclEntry
-- Copyright   : (c) 2013-2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

-- | Replaces an entry (rule) in a network ACL. For more information about
-- network ACLs, see Network ACLs in the Amazon Virtual Private Cloud User
-- Guide. Example This example replaces the egress entry numbered 110 in the
-- network ACL with ID acl-2cb85d45. The new rule denies egress traffic
-- destined for anywhere (0.0.0.0/0) on TCP port 139.
-- https://ec2.amazonaws.com/?Action=ReplaceNetworkAclEntry
-- &amp;NetworkAclId=acl-2cb85d45 &amp;RuleNumber=110 &amp;Protocol=tcp
-- &amp;RuleAction=deny &amp;Egress=true &amp;CidrBlock=0.0.0.0/0
-- &amp;PortRange.From=139 &amp;PortRange.To=139 &amp;AUTHPARAMS
-- &lt;ReplaceNetworkAclEntryResponse
-- xmlns="http://ec2.amazonaws.com/doc/2013-10-01/"&gt;
-- &lt;requestId&gt;59dbff89-35bd-4eac-99ed-be587EXAMPLE&lt;/requestId&gt;
-- &lt;return&gt;true&lt;/return&gt; &lt;/ReplaceNetworkAclEntryResponse&gt;.
module Network.AWS.EC2.V2014_05_01.ReplaceNetworkAclEntry where

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

data ReplaceNetworkAclEntry = ReplaceNetworkAclEntry
    { _rnaerEgress :: Bool
      -- ^ Indicates whether to replace the egress rule. Default: If no
      -- value is specified, we replace the ingress rule.
    , _rnaerRuleNumber :: Integer
      -- ^ The rule number of the entry to replace.
    , _rnaerRuleAction :: RuleAction
      -- ^ Indicates whether to allow or deny the traffic that matches the
      -- rule.
    , _rnaerNetworkAclId :: Text
      -- ^ The ID of the ACL.
    , _rnaerProtocol :: Text
      -- ^ The IP protocol. You can specify all or -1 to mean all protocols.
    , _rnaerCidrBlock :: Text
      -- ^ The network range to allow or deny, in CIDR notation.
    , _rnaerDryRun :: Maybe Bool
      -- ^ 
    , _rnaerIcmpTypeCode :: Maybe IcmpTypeCode
      -- ^ ICMP protocol: The ICMP type and code.
    , _rnaerPortRange :: Maybe PortRange
      -- ^ TCP or UDP protocols: The range of ports the rule applies to.
    } deriving (Generic)

instance ToQuery ReplaceNetworkAclEntry where
    toQuery = genericToQuery def

instance AWSRequest ReplaceNetworkAclEntry where
    type Sv ReplaceNetworkAclEntry = EC2
    type Rs ReplaceNetworkAclEntry = ReplaceNetworkAclEntryResponse

    request = post "ReplaceNetworkAclEntry"
    response _ _ = return (Right ReplaceNetworkAclEntryResponse)

data ReplaceNetworkAclEntryResponse = ReplaceNetworkAclEntryResponse
    deriving (Eq, Show, Generic)
