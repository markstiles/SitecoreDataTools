
------ DROP THE TABLE AND CONSTRAINTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_CF_ContactBehaviorProfiles]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[CF_ContactBehaviorProfiles]
DROP CONSTRAINT [PK_CF_ContactBehaviorProfiles]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[CF_ContactBehaviorProfiles]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[CF_ContactBehaviorProfiles]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [CF_ContactBehaviorProfiles](
	[ContactBehaviorProfileId] [uniqueidentifier] NOT NULL
	,[ContactId] [uniqueidentifier] NULL
    ,[ProfileId] [uniqueidentifier]
	,[PatternCardId] [uniqueidentifier]
	,[ScoreCount] [int]
	,[Score] [float]
	,[ProfileKeyId] [uniqueidentifier]
	,[ProfileKeyValue] [float]
	,[SourceInteractionStartDateTime] [datetime2](7)
 CONSTRAINT [PK_CF_ContactBehaviorProfiles] PRIMARY KEY CLUSTERED 
(
	[ContactBehaviorProfileId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[CF_ContactBehaviorProfiles]
SELECT 
	NEWID()
	,cf.ContactId
    ,iv.ProfileId
	,iv.PatternCardId
	,iv.ScoreCount
	,iv.Score
	,pkv.ProfileKeyId
	,pkv.ProfileKeyValue 
	,f.SourceInteractionStartDateTime
FROM ${shard0}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	Scores NVARCHAR(MAX) '$.Scores' AS JSON
	,SourceInteractionStartDateTime datetime2(7)
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
WHERE cf.FacetKey = 'ContactBehaviorProfile'
AND f.SourceInteractionStartDateTime is not null

INSERT INTO ${warehouse}.[dbo].[CF_ContactBehaviorProfiles]
SELECT 
	NEWID()
	,cf.ContactId
    ,iv.ProfileId
	,iv.PatternCardId
	,iv.ScoreCount
	,iv.Score
	,pkv.ProfileKeyId
	,pkv.ProfileKeyValue 
	,f.SourceInteractionStartDateTime
FROM ${shard1}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	Scores NVARCHAR(MAX) '$.Scores' AS JSON
	,SourceInteractionStartDateTime datetime2(7)
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
WHERE cf.FacetKey = 'ContactBehaviorProfile'
AND f.SourceInteractionStartDateTime is not null