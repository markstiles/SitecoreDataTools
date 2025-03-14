
------ DROP THE TABLE AND CONSTRAINTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_IF_IpInfos]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[IF_IpInfos]
DROP CONSTRAINT [PK_IF_IpInfos]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[IF_IpInfos]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[IF_IpInfos]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [IF_IpInfos](
	[IpInfoId] [uniqueidentifier] NOT NULL
	,[InteractionId] [uniqueidentifier] NULL
	,[ContactId] [uniqueidentifier] NULL
    ,[IpAddress] [nvarchar](50)
	,[LocationId] [uniqueidentifier]
 CONSTRAINT [PK_IF_IpInfos] PRIMARY KEY CLUSTERED 
(
	[IpInfoId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[IF_IpInfos]
SELECT 
	NEWID()
	,iaf.InteractionId
	,iaf.ContactId
	,f.IpAddress
	,f.LocationId
FROM ${shard0}.[xdb_collection].[InteractionFacets] iaf
CROSS APPLY OPENJSON(iaf.FacetData) WITH (
	IpAddress nvarchar(50) '$.IpAddress'
	,LocationId uniqueidentifier '$.LocationId'
) f
WHERE iaf.FacetKey = 'IpInfo'

INSERT INTO ${warehouse}.[dbo].[IF_IpInfos]
SELECT 
	NEWID()
	,iaf.InteractionId
	,iaf.ContactId
	,f.IpAddress
	,f.LocationId
FROM ${shard1}.[xdb_collection].[InteractionFacets] iaf
CROSS APPLY OPENJSON(iaf.FacetData) WITH (
	IpAddress nvarchar(50) '$.IpAddress'
	,LocationId uniqueidentifier '$.LocationId'
) f
WHERE iaf.FacetKey = 'IpInfo'