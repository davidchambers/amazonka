{-# LANGUAGE OverloadedStrings #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.DMS.Types
-- Copyright   : (c) 2013-2016 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
module Network.AWS.DMS.Types
    (
    -- * Service Configuration
      dms

    -- * Errors
    , _InvalidSubnet
    , _KMSKeyNotAccessibleFault
    , _ReplicationSubnetGroupDoesNotCoverEnoughAZs
    , _InvalidResourceStateFault
    , _InvalidCertificateFault
    , _ResourceAlreadyExistsFault
    , _InsufficientResourceCapacityFault
    , _ResourceQuotaExceededFault
    , _UpgradeDependencyFailureFault
    , _ResourceNotFoundFault
    , _StorageQuotaExceededFault
    , _AccessDeniedFault
    , _SubnetAlreadyInUse

    -- * DmsSSLModeValue
    , DmsSSLModeValue (..)

    -- * MigrationTypeValue
    , MigrationTypeValue (..)

    -- * RefreshSchemasStatusTypeValue
    , RefreshSchemasStatusTypeValue (..)

    -- * ReplicationEndpointTypeValue
    , ReplicationEndpointTypeValue (..)

    -- * StartReplicationTaskTypeValue
    , StartReplicationTaskTypeValue (..)

    -- * AccountQuota
    , AccountQuota
    , accountQuota
    , aqMax
    , aqUsed
    , aqAccountQuotaName

    -- * AvailabilityZone
    , AvailabilityZone
    , availabilityZone
    , azName

    -- * Certificate
    , Certificate
    , certificate
    , cCertificateOwner
    , cSigningAlgorithm
    , cValidFromDate
    , cCertificatePem
    , cCertificateARN
    , cCertificateCreationDate
    , cCertificateIdentifier
    , cKeyLength
    , cValidToDate

    -- * Connection
    , Connection
    , connection
    , cStatus
    , cReplicationInstanceARN
    , cEndpointIdentifier
    , cReplicationInstanceIdentifier
    , cEndpointARN
    , cLastFailureMessage

    -- * Endpoint
    , Endpoint
    , endpoint
    , eStatus
    , eServerName
    , eCertificateARN
    , eExtraConnectionAttributes
    , eEndpointType
    , eUsername
    , eEngineName
    , eKMSKeyId
    , eSSLMode
    , eDatabaseName
    , eEndpointIdentifier
    , eEndpointARN
    , ePort

    -- * Filter
    , Filter
    , filter'
    , fName
    , fValues

    -- * OrderableReplicationInstance
    , OrderableReplicationInstance
    , orderableReplicationInstance
    , oriEngineVersion
    , oriMinAllocatedStorage
    , oriIncludedAllocatedStorage
    , oriMaxAllocatedStorage
    , oriReplicationInstanceClass
    , oriDefaultAllocatedStorage
    , oriStorageType

    -- * RefreshSchemasStatus
    , RefreshSchemasStatus
    , refreshSchemasStatus
    , rssStatus
    , rssLastRefreshDate
    , rssReplicationInstanceARN
    , rssEndpointARN
    , rssLastFailureMessage

    -- * ReplicationInstance
    , ReplicationInstance
    , replicationInstance
    , riEngineVersion
    , riPubliclyAccessible
    , riAutoMinorVersionUpgrade
    , riReplicationInstancePublicIPAddresses
    , riReplicationSubnetGroup
    , riInstanceCreateTime
    , riReplicationInstanceStatus
    , riReplicationInstancePrivateIPAddresses
    , riPreferredMaintenanceWindow
    , riReplicationInstancePrivateIPAddress
    , riKMSKeyId
    , riAvailabilityZone
    , riVPCSecurityGroups
    , riMultiAZ
    , riReplicationInstanceARN
    , riAllocatedStorage
    , riReplicationInstancePublicIPAddress
    , riReplicationInstanceClass
    , riReplicationInstanceIdentifier
    , riPendingModifiedValues

    -- * ReplicationPendingModifiedValues
    , ReplicationPendingModifiedValues
    , replicationPendingModifiedValues
    , rpmvEngineVersion
    , rpmvMultiAZ
    , rpmvAllocatedStorage
    , rpmvReplicationInstanceClass

    -- * ReplicationSubnetGroup
    , ReplicationSubnetGroup
    , replicationSubnetGroup
    , rsgVPCId
    , rsgSubnets
    , rsgReplicationSubnetGroupIdentifier
    , rsgSubnetGroupStatus
    , rsgReplicationSubnetGroupDescription

    -- * ReplicationTask
    , ReplicationTask
    , replicationTask
    , rtReplicationTaskSettings
    , rtStatus
    , rtTargetEndpointARN
    , rtReplicationTaskIdentifier
    , rtReplicationTaskStartDate
    , rtSourceEndpointARN
    , rtTableMappings
    , rtReplicationTaskCreationDate
    , rtMigrationType
    , rtReplicationTaskARN
    , rtReplicationTaskStats
    , rtReplicationInstanceARN
    , rtLastFailureMessage

    -- * ReplicationTaskStats
    , ReplicationTaskStats
    , replicationTaskStats
    , rtsFullLoadProgressPercent
    , rtsElapsedTimeMillis
    , rtsTablesErrored
    , rtsTablesLoaded
    , rtsTablesQueued
    , rtsTablesLoading

    -- * Subnet
    , Subnet
    , subnet
    , sSubnetStatus
    , sSubnetIdentifier
    , sSubnetAvailabilityZone

    -- * SupportedEndpointType
    , SupportedEndpointType
    , supportedEndpointType
    , setEndpointType
    , setEngineName
    , setSupportsCDC

    -- * TableStatistics
    , TableStatistics
    , tableStatistics
    , tsFullLoadRows
    , tsInserts
    , tsSchemaName
    , tsTableState
    , tsDdls
    , tsDeletes
    , tsUpdates
    , tsLastUpdateTime
    , tsTableName

    -- * Tag
    , Tag
    , tag
    , tagValue
    , tagKey

    -- * VPCSecurityGroupMembership
    , VPCSecurityGroupMembership
    , vpcSecurityGroupMembership
    , vsgmStatus
    , vsgmVPCSecurityGroupId
    ) where

import           Network.AWS.DMS.Types.Product
import           Network.AWS.DMS.Types.Sum
import           Network.AWS.Lens
import           Network.AWS.Prelude
import           Network.AWS.Sign.V4

-- | API version @2016-01-01@ of the Amazon Database Migration Service SDK configuration.
dms :: Service
dms =
    Service
    { _svcAbbrev = "DMS"
    , _svcSigner = v4
    , _svcPrefix = "dms"
    , _svcVersion = "2016-01-01"
    , _svcEndpoint = defaultEndpoint dms
    , _svcTimeout = Just 70
    , _svcCheck = statusSuccess
    , _svcError = parseJSONError "DMS"
    , _svcRetry = retry
    }
  where
    retry =
        Exponential
        { _retryBase = 5.0e-2
        , _retryGrowth = 2
        , _retryAttempts = 5
        , _retryCheck = check
        }
    check e
      | has (hasStatus 429) e = Just "too_many_requests"
      | has (hasCode "ThrottlingException" . hasStatus 400) e =
          Just "throttling_exception"
      | has (hasCode "Throttling" . hasStatus 400) e = Just "throttling"
      | has (hasStatus 504) e = Just "gateway_timeout"
      | has (hasStatus 502) e = Just "bad_gateway"
      | has (hasStatus 503) e = Just "service_unavailable"
      | has (hasStatus 500) e = Just "general_server_error"
      | has (hasStatus 509) e = Just "limit_exceeded"
      | otherwise = Nothing

-- | The subnet provided is invalid.
--
--
_InvalidSubnet :: AsError a => Getting (First ServiceError) a ServiceError
_InvalidSubnet = _MatchServiceError dms "InvalidSubnet"

-- | AWS DMS cannot access the KMS key.
--
--
_KMSKeyNotAccessibleFault :: AsError a => Getting (First ServiceError) a ServiceError
_KMSKeyNotAccessibleFault = _MatchServiceError dms "KMSKeyNotAccessibleFault"

-- | The replication subnet group does not cover enough Availability Zones (AZs). Edit the replication subnet group and add more AZs.
--
--
_ReplicationSubnetGroupDoesNotCoverEnoughAZs :: AsError a => Getting (First ServiceError) a ServiceError
_ReplicationSubnetGroupDoesNotCoverEnoughAZs =
    _MatchServiceError dms "ReplicationSubnetGroupDoesNotCoverEnoughAZs"

-- | The resource is in a state that prevents it from being used for database migration.
--
--
_InvalidResourceStateFault :: AsError a => Getting (First ServiceError) a ServiceError
_InvalidResourceStateFault = _MatchServiceError dms "InvalidResourceStateFault"

-- | The certificate was not valid.
--
--
_InvalidCertificateFault :: AsError a => Getting (First ServiceError) a ServiceError
_InvalidCertificateFault = _MatchServiceError dms "InvalidCertificateFault"

-- | The resource you are attempting to create already exists.
--
--
_ResourceAlreadyExistsFault :: AsError a => Getting (First ServiceError) a ServiceError
_ResourceAlreadyExistsFault =
    _MatchServiceError dms "ResourceAlreadyExistsFault"

-- | There are not enough resources allocated to the database migration.
--
--
_InsufficientResourceCapacityFault :: AsError a => Getting (First ServiceError) a ServiceError
_InsufficientResourceCapacityFault =
    _MatchServiceError dms "InsufficientResourceCapacityFault"

-- | The quota for this resource quota has been exceeded.
--
--
_ResourceQuotaExceededFault :: AsError a => Getting (First ServiceError) a ServiceError
_ResourceQuotaExceededFault =
    _MatchServiceError dms "ResourceQuotaExceededFault"

-- | An upgrade dependency is preventing the database migration.
--
--
_UpgradeDependencyFailureFault :: AsError a => Getting (First ServiceError) a ServiceError
_UpgradeDependencyFailureFault =
    _MatchServiceError dms "UpgradeDependencyFailureFault"

-- | The resource could not be found.
--
--
_ResourceNotFoundFault :: AsError a => Getting (First ServiceError) a ServiceError
_ResourceNotFoundFault = _MatchServiceError dms "ResourceNotFoundFault"

-- | The storage quota has been exceeded.
--
--
_StorageQuotaExceededFault :: AsError a => Getting (First ServiceError) a ServiceError
_StorageQuotaExceededFault = _MatchServiceError dms "StorageQuotaExceededFault"

-- | AWS DMS was denied access to the endpoint.
--
--
_AccessDeniedFault :: AsError a => Getting (First ServiceError) a ServiceError
_AccessDeniedFault = _MatchServiceError dms "AccessDeniedFault"

-- | The specified subnet is already in use.
--
--
_SubnetAlreadyInUse :: AsError a => Getting (First ServiceError) a ServiceError
_SubnetAlreadyInUse = _MatchServiceError dms "SubnetAlreadyInUse"
