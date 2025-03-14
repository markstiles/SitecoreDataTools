
------ DROP THE TABLE AND CONSTRAINTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_IF_UserAgentInfo]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[IF_UserAgentInfo]
DROP CONSTRAINT [PK_IF_UserAgentInfo]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[IF_UserAgentInfo]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[IF_UserAgentInfo]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [IF_UserAgentInfo](
	[UserAgentInfoId] [uniqueidentifier] NOT NULL
	,[InteractionId] [uniqueidentifier] NULL
	,[ContactId] [uniqueidentifier] NULL
    ,[DeviceType] [nvarchar](50)
 CONSTRAINT [PK_IF_UserAgentInfo] PRIMARY KEY CLUSTERED 
(
	[UserAgentInfoId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[IF_UserAgentInfo]
SELECT 
	NEWID()
	,iaf.InteractionId
	,iaf.ContactId
	,f.DeviceType as Device
FROM ${shard0}.[xdb_collection].[InteractionFacets] iaf
CROSS APPLY OPENJSON(iaf.FacetData) WITH (
	DeviceType nvarchar(50) '$.DeviceType'
) f
WHERE iaf.FacetKey = 'UserAgentInfo'

INSERT INTO ${warehouse}.[dbo].[IF_serAgentInfo]
SELECT 
	NEWID()
	,iaf.InteractionId
	,iaf.ContactId
	,f.DeviceType as Device
FROM ${shard1}.[xdb_collection].[InteractionFacets] iaf
CROSS APPLY OPENJSON(iaf.FacetData) WITH (
	DeviceType nvarchar(50) '$.DeviceType'
) f
WHERE iaf.FacetKey = 'UserAgentInfo'