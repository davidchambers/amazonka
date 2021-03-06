{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE LambdaCase         #-}
{-# LANGUAGE OverloadedStrings  #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.ELBv2.Types.Sum
-- Copyright   : (c) 2013-2016 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
module Network.AWS.ELBv2.Types.Sum where

import           Network.AWS.Prelude

data ActionTypeEnum =
    Forward
    deriving (Eq,Ord,Read,Show,Enum,Bounded,Data,Typeable,Generic)

instance FromText ActionTypeEnum where
    parser = takeLowerText >>= \case
        "forward" -> pure Forward
        e -> fromTextError $ "Failure parsing ActionTypeEnum from value: '" <> e
           <> "'. Accepted values: forward"

instance ToText ActionTypeEnum where
    toText = \case
        Forward -> "forward"

instance Hashable     ActionTypeEnum
instance NFData       ActionTypeEnum
instance ToByteString ActionTypeEnum
instance ToQuery      ActionTypeEnum
instance ToHeader     ActionTypeEnum

instance FromXML ActionTypeEnum where
    parseXML = parseXMLText "ActionTypeEnum"

data LoadBalancerSchemeEnum
    = Internal
    | InternetFacing
    deriving (Eq,Ord,Read,Show,Enum,Bounded,Data,Typeable,Generic)

instance FromText LoadBalancerSchemeEnum where
    parser = takeLowerText >>= \case
        "internal" -> pure Internal
        "internet-facing" -> pure InternetFacing
        e -> fromTextError $ "Failure parsing LoadBalancerSchemeEnum from value: '" <> e
           <> "'. Accepted values: internal, internet-facing"

instance ToText LoadBalancerSchemeEnum where
    toText = \case
        Internal -> "internal"
        InternetFacing -> "internet-facing"

instance Hashable     LoadBalancerSchemeEnum
instance NFData       LoadBalancerSchemeEnum
instance ToByteString LoadBalancerSchemeEnum
instance ToQuery      LoadBalancerSchemeEnum
instance ToHeader     LoadBalancerSchemeEnum

instance FromXML LoadBalancerSchemeEnum where
    parseXML = parseXMLText "LoadBalancerSchemeEnum"

data LoadBalancerStateEnum
    = Active
    | Failed
    | Provisioning
    deriving (Eq,Ord,Read,Show,Enum,Bounded,Data,Typeable,Generic)

instance FromText LoadBalancerStateEnum where
    parser = takeLowerText >>= \case
        "active" -> pure Active
        "failed" -> pure Failed
        "provisioning" -> pure Provisioning
        e -> fromTextError $ "Failure parsing LoadBalancerStateEnum from value: '" <> e
           <> "'. Accepted values: active, failed, provisioning"

instance ToText LoadBalancerStateEnum where
    toText = \case
        Active -> "active"
        Failed -> "failed"
        Provisioning -> "provisioning"

instance Hashable     LoadBalancerStateEnum
instance NFData       LoadBalancerStateEnum
instance ToByteString LoadBalancerStateEnum
instance ToQuery      LoadBalancerStateEnum
instance ToHeader     LoadBalancerStateEnum

instance FromXML LoadBalancerStateEnum where
    parseXML = parseXMLText "LoadBalancerStateEnum"

data LoadBalancerTypeEnum =
    Application
    deriving (Eq,Ord,Read,Show,Enum,Bounded,Data,Typeable,Generic)

instance FromText LoadBalancerTypeEnum where
    parser = takeLowerText >>= \case
        "application" -> pure Application
        e -> fromTextError $ "Failure parsing LoadBalancerTypeEnum from value: '" <> e
           <> "'. Accepted values: application"

instance ToText LoadBalancerTypeEnum where
    toText = \case
        Application -> "application"

instance Hashable     LoadBalancerTypeEnum
instance NFData       LoadBalancerTypeEnum
instance ToByteString LoadBalancerTypeEnum
instance ToQuery      LoadBalancerTypeEnum
instance ToHeader     LoadBalancerTypeEnum

instance FromXML LoadBalancerTypeEnum where
    parseXML = parseXMLText "LoadBalancerTypeEnum"

data ProtocolEnum
    = HTTP
    | HTTPS
    deriving (Eq,Ord,Read,Show,Enum,Bounded,Data,Typeable,Generic)

instance FromText ProtocolEnum where
    parser = takeLowerText >>= \case
        "http" -> pure HTTP
        "https" -> pure HTTPS
        e -> fromTextError $ "Failure parsing ProtocolEnum from value: '" <> e
           <> "'. Accepted values: http, https"

instance ToText ProtocolEnum where
    toText = \case
        HTTP -> "HTTP"
        HTTPS -> "HTTPS"

instance Hashable     ProtocolEnum
instance NFData       ProtocolEnum
instance ToByteString ProtocolEnum
instance ToQuery      ProtocolEnum
instance ToHeader     ProtocolEnum

instance FromXML ProtocolEnum where
    parseXML = parseXMLText "ProtocolEnum"

data TargetHealthReasonEnum
    = Elb_InitialHealthChecking
    | Elb_InternalError
    | Elb_RegistrationInProgress
    | Target_DeregistrationInProgress
    | Target_FailedHealthChecks
    | Target_InvalidState
    | Target_NotInUse
    | Target_NotRegistered
    | Target_ResponseCodeMismatch
    | Target_Timeout
    deriving (Eq,Ord,Read,Show,Enum,Bounded,Data,Typeable,Generic)

instance FromText TargetHealthReasonEnum where
    parser = takeLowerText >>= \case
        "elb.initialhealthchecking" -> pure Elb_InitialHealthChecking
        "elb.internalerror" -> pure Elb_InternalError
        "elb.registrationinprogress" -> pure Elb_RegistrationInProgress
        "target.deregistrationinprogress" -> pure Target_DeregistrationInProgress
        "target.failedhealthchecks" -> pure Target_FailedHealthChecks
        "target.invalidstate" -> pure Target_InvalidState
        "target.notinuse" -> pure Target_NotInUse
        "target.notregistered" -> pure Target_NotRegistered
        "target.responsecodemismatch" -> pure Target_ResponseCodeMismatch
        "target.timeout" -> pure Target_Timeout
        e -> fromTextError $ "Failure parsing TargetHealthReasonEnum from value: '" <> e
           <> "'. Accepted values: elb.initialhealthchecking, elb.internalerror, elb.registrationinprogress, target.deregistrationinprogress, target.failedhealthchecks, target.invalidstate, target.notinuse, target.notregistered, target.responsecodemismatch, target.timeout"

instance ToText TargetHealthReasonEnum where
    toText = \case
        Elb_InitialHealthChecking -> "Elb.InitialHealthChecking"
        Elb_InternalError -> "Elb.InternalError"
        Elb_RegistrationInProgress -> "Elb.RegistrationInProgress"
        Target_DeregistrationInProgress -> "Target.DeregistrationInProgress"
        Target_FailedHealthChecks -> "Target.FailedHealthChecks"
        Target_InvalidState -> "Target.InvalidState"
        Target_NotInUse -> "Target.NotInUse"
        Target_NotRegistered -> "Target.NotRegistered"
        Target_ResponseCodeMismatch -> "Target.ResponseCodeMismatch"
        Target_Timeout -> "Target.Timeout"

instance Hashable     TargetHealthReasonEnum
instance NFData       TargetHealthReasonEnum
instance ToByteString TargetHealthReasonEnum
instance ToQuery      TargetHealthReasonEnum
instance ToHeader     TargetHealthReasonEnum

instance FromXML TargetHealthReasonEnum where
    parseXML = parseXMLText "TargetHealthReasonEnum"

data TargetHealthStateEnum
    = Draining
    | Healthy
    | Initial
    | Unhealthy
    | Unused
    deriving (Eq,Ord,Read,Show,Enum,Bounded,Data,Typeable,Generic)

instance FromText TargetHealthStateEnum where
    parser = takeLowerText >>= \case
        "draining" -> pure Draining
        "healthy" -> pure Healthy
        "initial" -> pure Initial
        "unhealthy" -> pure Unhealthy
        "unused" -> pure Unused
        e -> fromTextError $ "Failure parsing TargetHealthStateEnum from value: '" <> e
           <> "'. Accepted values: draining, healthy, initial, unhealthy, unused"

instance ToText TargetHealthStateEnum where
    toText = \case
        Draining -> "draining"
        Healthy -> "healthy"
        Initial -> "initial"
        Unhealthy -> "unhealthy"
        Unused -> "unused"

instance Hashable     TargetHealthStateEnum
instance NFData       TargetHealthStateEnum
instance ToByteString TargetHealthStateEnum
instance ToQuery      TargetHealthStateEnum
instance ToHeader     TargetHealthStateEnum

instance FromXML TargetHealthStateEnum where
    parseXML = parseXMLText "TargetHealthStateEnum"
