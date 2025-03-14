
------ DROP THE TABLE AND CONSTRAINTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_IF_WebVisits]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[IF_WebVisits]
DROP CONSTRAINT [PK_IF_WebVisits]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[IF_WebVisits]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[IF_WebVisits]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [IF_WebVisits](
	[WebVisitId] [uniqueidentifier] NOT NULL
	,[InteractionId] [uniqueidentifier] NULL
	,[ContactId] [uniqueidentifier] NULL
	,[Browser] [nvarchar](50)
	,[OperatingSystem] [nvarchar](50)
	,[Referrer] [nvarchar](max)
	,[IsSelfReferrer] [bit]
	,[SearchKeywords] [nvarchar](max)
 CONSTRAINT [PK_IF_WebVisits] PRIMARY KEY CLUSTERED 
(
	[WebVisitId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[IF_WebVisits]
SELECT 
	NEWID()
	,iaf.InteractionId
	,iaf.ContactId
	,f.Browser
	,f.OperatingSystem as OS
	,f.Referrer
	,f.IsSelfReferrer
	,f.SearchKeywords
FROM ${shard0}.[xdb_collection].[InteractionFacets] iaf
CROSS APPLY OPENJSON(iaf.FacetData) WITH (
	Browser nvarchar(50) '$.Browser.BrowserMajorName'
	,OperatingSystem nvarchar(500) '$.OperatingSystem.Name'
	,Referrer nvarchar(MAX) '$.Referrer'
	,IsSelfReferrer bit '$.IsSelfReferrer'
	,SearchKeywords nvarchar(MAX) '$.SearchKeywords'
	,SiteName nvarchar(50) '$.SiteName'
) f
WHERE iaf.FacetKey = 'WebVisit'

INSERT INTO ${warehouse}.[dbo].[IF_WebVisits]
SELECT 
	NEWID()
	,iaf.InteractionId
	,iaf.ContactId
	,f.Browser
	,f.OperatingSystem as OS
	,f.Referrer
	,f.IsSelfReferrer
	,f.SearchKeywords
FROM ${shard1}.[xdb_collection].[InteractionFacets] iaf
CROSS APPLY OPENJSON(iaf.FacetData) WITH (
	Browser nvarchar(50) '$.Browser.BrowserMajorName'
	,OperatingSystem nvarchar(500) '$.OperatingSystem.Name'
	,Referrer nvarchar(MAX) '$.Referrer'
	,IsSelfReferrer bit '$.IsSelfReferrer'
	,SearchKeywords nvarchar(MAX) '$.SearchKeywords'
	,SiteName nvarchar(50) '$.SiteName'
) f
WHERE iaf.FacetKey = 'WebVisit'