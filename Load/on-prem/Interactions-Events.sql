
------ UPDATE COMPATIBILITY LEVEL ON CONTENT DB -----------------------------------

ALTER DATABASE ${items} SET COMPATIBILITY_LEVEL = 130;

------ DROP THE TABLE AND CONSTRAINTS IF EXISTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_I_Events]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[I_Events]
DROP CONSTRAINT [PK_I_Events]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[I_Events]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[I_Events]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [I_Events](
	[InteractionEventId] [uniqueidentifier] NOT NULL
	,[InteractionId] [uniqueidentifier] NOT NULL
	,[ContactId] [uniqueidentifier] NOT NULL
    ,[StartDateTime] [datetime2](7) NOT NULL
    ,[EndDateTime] [datetime2](7) NOT NULL
    ,[DeviceProfileId] [uniqueidentifier] NULL
    ,[ChannelId] [uniqueidentifier] NOT NULL
    ,[VenueId] [uniqueidentifier] NULL
    ,[CampaignId] [uniqueidentifier] NULL
    ,[UserAgent] [nvarchar](900) NOT NULL
    ,[Percentile] [float] NOT NULL
	,[EventType] [nvarchar](max) NULL
	,[CustomValues] [nvarchar](max) NULL
	,[DefinitionId] [nvarchar](max) NULL
	,[ItemId] [uniqueidentifier] NULL
	,[Id] [uniqueidentifier] NULL
	,[Timestamp] [datetime2](7) NULL
	,[Duration] [nvarchar](50) NULL
	,[ItemLanguage] [nvarchar](50) NULL
	,[ItemVersion] [int] NULL
	,[Url] [nvarchar](max) NULL
	,[DeviceName] [nvarchar](50) NULL
	,[Data] [nvarchar](max) NULL
	,[DataKey] [nvarchar](max) NULL
	,[ParentEventId] [uniqueidentifier] NULL
	,[Text] [nvarchar](max) NULL
	,[EngagementValue] [int] NULL DEFAULT 0
	,[Combination] [nvarchar](50)
	,[ExposureTime] [datetime2](7)
	,[FirstExposure] [bit] NULL
	,[ValueAtExposure] [int] NULL
	,[ContactVisitIndex] [int]
	,[DeviceType] [nvarchar](50)
	,[CampaignDefinitionId] [uniqueidentifier]
	,[Delta] [nvarchar](max)
	,[ExposedRules] [nvarchar](max)
	,[EligibleRules] [nvarchar](max)
 CONSTRAINT [PK_I_Events] PRIMARY KEY CLUSTERED 
(
	[InteractionEventId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[I_Events]
SELECT 
	NEWID()
	,i.InteractionId
	,i.ContactId
	,i.StartDateTime
	,i.EndDateTime
	,i.DeviceProfileId
	,i.ChannelId
	,i.VenueId
	,i.CampaignId
	,i.UserAgent
	,i.Percentile
	,j.odatatype
	,j.CustomValues
	,j.DefinitionId
    ,j.ItemId
	,j.Id
	,j.Timestamp
	,j.Duration
	,j.ItemLanguage
	,j.ItemVersion
	,j.Url
	,j.DeviceName
	,j.Data
	,j.DataKey
	,j.ParentEventId
	,j.Text
	,j.EngagementValue
	,j.Combination
	,j.ExposureTime 
	,j.FirstExposure
	,j.ValueAtExposure
	,j.ContactVisitIndex
	,j.DeviceType
	,j.CampaignDefinitionId
	,j.Delta
	,j.ExposedRules
	,j.EligibleRules
FROM ${shard0}.[xdb_collection].[Interactions] i
CROSS APPLY OPENJSON(i.Events) WITH (
	odatatype nvarchar(MAX) '$."@odata.type"'
	,CustomValues nvarchar(MAX) '$.CustomValues'
	,DefinitionId uniqueidentifier '$.DefinitionId'
	,ItemId uniqueidentifier '$.ItemId'
	,Id uniqueidentifier '$.Id'
	,Timestamp datetime2(7) '$.Timestamp'
	,Duration nvarchar(50) '$.Duration'
	,ItemLanguage nvarchar(50) '$.ItemLanguage'
	,ItemVersion int '$.ItemVersion'
	,Url nvarchar(MAX) '$.Url'
	,DeviceName nvarchar(50) '$.SitecoreRenderingDevice.Name'
	,Data nvarchar(MAX) '$.Data'
	,DataKey nvarchar(MAX) '$.DataKey'
	,ParentEventId uniqueidentifier '$.ParentEventId'
	,Text nvarchar(MAX) '$.Text'
	,EngagementValue int '$.EngagementValue'
	,Combination nvarchar(50) '$.Combination'
	,ExposureTime datetime2(7) '$.ExposureTime'
	,FirstExposure bit '$.FirstExposure'
	,ValueAtExposure int '$.ValueAtExposure'
	,ContactVisitIndex int '$.ContactVisitIndex'
	,DeviceType nvarchar(50) '$.DeviceType'
	,CampaignDefinitionId uniqueidentifier '$.CampaignDefinitionId'
	,Delta nvarchar(max) '$.Delta' AS JSON
	,ExposedRules nvarchar(max) '$.ExposedRules' AS JSON
	,EligibleRules nvarchar(max) '$.EligibleRules' AS JSON
) j

INSERT INTO ${warehouse}.[dbo].[I_Events]
SELECT 
	NEWID()
	,i.InteractionId
	,i.ContactId
	,i.StartDateTime
	,i.EndDateTime
	,i.DeviceProfileId
	,i.ChannelId
	,i.VenueId
	,i.CampaignId
	,i.UserAgent
	,i.Percentile
	,j.odatatype
	,j.CustomValues
	,j.DefinitionId
    ,j.ItemId
	,j.Id
	,j.Timestamp
	,j.Duration
	,j.ItemLanguage
	,j.ItemVersion
	,j.Url
	,j.DeviceName
	,j.Data
	,j.DataKey
	,j.ParentEventId
	,j.Text
	,j.EngagementValue
	,j.Combination
	,j.ExposureTime 
	,j.FirstExposure
	,j.ValueAtExposure
	,j.ContactVisitIndex
	,j.DeviceType
	,j.CampaignDefinitionId
	,j.Delta
	,j.ExposedRules
	,j.EligibleRules
FROM ${shard1}.[xdb_collection].[Interactions] i
CROSS APPLY OPENJSON(i.Events) WITH (
	odatatype nvarchar(MAX) '$."@odata.type"'
	,CustomValues nvarchar(MAX) '$.CustomValues'
	,DefinitionId uniqueidentifier '$.DefinitionId'
	,ItemId uniqueidentifier '$.ItemId'
	,Id uniqueidentifier '$.Id'
	,Timestamp datetime2(7) '$.Timestamp'
	,Duration nvarchar(50) '$.Duration'
	,ItemLanguage nvarchar(50) '$.ItemLanguage'
	,ItemVersion int '$.ItemVersion'
	,Url nvarchar(MAX) '$.Url'
	,DeviceName nvarchar(50) '$.SitecoreRenderingDevice.Name'
	,Data nvarchar(MAX) '$.Data'
	,DataKey nvarchar(MAX) '$.DataKey'
	,ParentEventId uniqueidentifier '$.ParentEventId'
	,Text nvarchar(MAX) '$.Text'
	,EngagementValue int '$.EngagementValue'
	,Combination nvarchar(50) '$.Combination'
	,ExposureTime datetime2(7) '$.ExposureTime'
	,FirstExposure bit '$.FirstExposure'
	,ValueAtExposure int '$.ValueAtExposure'
	,ContactVisitIndex int '$.ContactVisitIndex'
	,DeviceType nvarchar(50) '$.DeviceType'
	,CampaignDefinitionId uniqueidentifier '$.CampaignDefinitionId'
	,Delta nvarchar(max) '$.Delta' AS JSON
	,ExposedRules nvarchar(max) '$.ExposedRules' AS JSON
	,EligibleRules nvarchar(max) '$.EligibleRules' AS JSON
) j

--WHERE LastModified >= GETDATE() - 5

-------- Nested Recursive JSON Elements ------------
-- https://stackoverflow.com/questions/48469759/sql-server-recursively-get-into-nested-json-array-using-cross-apply-or-openjso
