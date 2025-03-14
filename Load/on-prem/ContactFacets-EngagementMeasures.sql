
------ DROP THE TABLE AND CONSTRAINTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_CF_EngagementMeasures]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[CF_EngagementMeasures]
DROP CONSTRAINT [PK_CF_EngagementMeasures]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[CF_EngagementMeasures]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[CF_EngagementMeasures]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [CF_EngagementMeasures](
	[EngagementMeasureId] [uniqueidentifier] NOT NULL
	,[ContactId] [uniqueidentifier] NULL
    ,[TotalInteractionCount] [nvarchar](50)
	,[TotalValue] [int]
	,[MostRecentInteractionStartDateTime] [datetime2](7)
	,[MostRecentInteractionDuration] [nvarchar](50)
	,[TotalInteractionDuration] [nvarchar](50)
	,[AverageInteractionDuration] [nvarchar](50)
 CONSTRAINT [PK_CF_EngagementMeasures] PRIMARY KEY CLUSTERED 
(
	[EngagementMeasureId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[CF_EngagementMeasures]
SELECT 
	NEWID()
	,cf.ContactId
	,f.TotalInteractionCount
	,f.TotalValue
	,f.MostRecentInteractionStartDateTime
	,f.MostRecentInteractionDuration
	,f.TotalInteractionDuration
	,f.AverageInteractionDuration
FROM ${shard0}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	TotalInteractionCount nvarchar(50) '$.TotalInteractionCount'
	,TotalValue int '$.TotalValue'
	,MostRecentInteractionStartDateTime datetime2(7) '$.MostRecentInteractionStartDateTime'
	,MostRecentInteractionDuration nvarchar(50) '$.MostRecentInteractionDuration'
	,TotalInteractionDuration nvarchar(50) '$.TotalInteractionDuration'
	,AverageInteractionDuration nvarchar(50) '$.AverageInteractionDuration'
) f
WHERE cf.FacetKey = 'EngagementMeasures'

INSERT INTO ${warehouse}.[dbo].[CF_EngagementMeasures]
SELECT 
	NEWID()
	,cf.ContactId
	,f.TotalInteractionCount
	,f.TotalValue
	,f.MostRecentInteractionStartDateTime
	,f.MostRecentInteractionDuration
	,f.TotalInteractionDuration
	,f.AverageInteractionDuration
FROM ${shard1}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	TotalInteractionCount nvarchar(50) '$.TotalInteractionCount'
	,TotalValue int '$.TotalValue'
	,MostRecentInteractionStartDateTime datetime2(7) '$.MostRecentInteractionStartDateTime'
	,MostRecentInteractionDuration nvarchar(50) '$.MostRecentInteractionDuration'
	,TotalInteractionDuration nvarchar(50) '$.TotalInteractionDuration'
	,AverageInteractionDuration nvarchar(50) '$.AverageInteractionDuration'
) f
WHERE cf.FacetKey = 'EngagementMeasures'