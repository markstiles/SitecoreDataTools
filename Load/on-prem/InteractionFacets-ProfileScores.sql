
------ DROP THE TABLE AND CONSTRAINTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_IF_ProfileScores]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[IF_ProfileScores]
DROP CONSTRAINT [PK_IF_ProfileScores]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[IF_ProfileScores]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[IF_ProfileScores]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [IF_ProfileScores](
	[ProfileScoreId] [uniqueidentifier] NOT NULL
	,[InteractionId] [uniqueidentifier] NULL
	,[ContactId] [uniqueidentifier] NULL
	,[ProfileId] [uniqueidentifier]
	,[PatternCardId] [uniqueidentifier]
	,[ScoreCount] [int]
	,[Score] [float]
	,[ProfileKeyId] [uniqueidentifier]
	,[ProfileKeyValue] [float]
 CONSTRAINT [PK_IF_ProfileScores] PRIMARY KEY CLUSTERED 
(
	[ProfileScoreId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[IF_ProfileScores]
SELECT 
	NEWID()
	,iaf.InteractionId
	,iaf.ContactId
	,iv.ProfileId
	,iv.PatternCardId
	,iv.ScoreCount
	,iv.Score
	,pkv.ProfileKeyId
	,pkv.ProfileKeyValue 
FROM ${shard0}.[xdb_collection].[InteractionFacets] iaf
CROSS APPLY OPENJSON(iaf.FacetData) WITH (
	Scores NVARCHAR(MAX) '$.Scores' AS JSON
) f
CROSS APPLY OPENJSON(f.Scores, '$') WITH (
	InnerValue nvarchar(max) '$.Value' AS JSON
) s
CROSS APPLY OPENJSON(s.InnerValue) WITH (
	ProfileId uniqueidentifier '$.ProfileDefinitionId'
	,PatternCardId uniqueidentifier '$.MatchedPatternId'
	,ScoreCount int '$.ScoreCount'
	,Score float '$.Score'
	,ProfileKeyValues nvarchar(max) '$.Values' AS JSON
) iv
CROSS APPLY OPENJSON(iv.ProfileKeyValues) WITH (
	ProfileKeyId uniqueidentifier '$.Key'
	,ProfileKeyValue float '$.Value'
) pkv
WHERE iaf.FacetKey = 'ProfileScores'

INSERT INTO ${warehouse}.[dbo].[IF_ProfileScores]
SELECT 
	NEWID()
	,iaf.InteractionId
	,iaf.ContactId
	,iv.ProfileId
	,iv.PatternCardId
	,iv.ScoreCount
	,iv.Score
	,pkv.ProfileKeyId
	,pkv.ProfileKeyValue 
FROM ${shard1}.[xdb_collection].[InteractionFacets] iaf
CROSS APPLY OPENJSON(iaf.FacetData) WITH (
	Scores NVARCHAR(MAX) '$.Scores' AS JSON
) f
CROSS APPLY OPENJSON(f.Scores, '$') WITH (
	InnerValue nvarchar(max) '$.Value' AS JSON
) s
CROSS APPLY OPENJSON(s.InnerValue) WITH (
	ProfileId uniqueidentifier '$.ProfileDefinitionId'
	,PatternCardId uniqueidentifier '$.MatchedPatternId'
	,ScoreCount int '$.ScoreCount'
	,Score float '$.Score'
	,ProfileKeyValues nvarchar(max) '$.Values' AS JSON
) iv
CROSS APPLY OPENJSON(iv.ProfileKeyValues) WITH (
	ProfileKeyId uniqueidentifier '$.Key'
	,ProfileKeyValue float '$.Value'
) pkv
WHERE iaf.FacetKey = 'ProfileScores'

GO--