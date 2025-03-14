
SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

------ DROP AND CREATE PROFILE, PROFILEKEY AND PATTERNCARD TABLE FROM MASTER -------------------------------

USE ${items}

IF EXISTS ( 
	SELECT 1 FROM sys.tables t 
	JOIN sys.schemas s ON t.schema_id = s.schema_id 
	WHERE t.name = N'TEMP_PROFILE_IDS' 
	AND s.name = N'dbo' 
) BEGIN DROP TABLE dbo.[TEMP_PROFILE_IDS] END
GO--

CREATE TABLE ${items}.[dbo].[TEMP_PROFILE_IDS](
	[ProfileId] [uniqueidentifier] NOT NULL
)
GO--

IF EXISTS ( 
	SELECT 1 FROM sys.tables t 
	JOIN sys.schemas s ON t.schema_id = s.schema_id 
	WHERE t.name = N'TEMP_PROFILEKEY_IDS' 
	AND s.name = N'dbo' 
) BEGIN DROP TABLE dbo.[TEMP_PROFILEKEY_IDS] END
GO--

CREATE TABLE ${items}.[dbo].[TEMP_PROFILEKEY_IDS](
	[ProfileKeyId] [uniqueidentifier] NOT NULL
	,[ProfileId] [uniqueidentifier] 
)
GO--

IF EXISTS ( 
	SELECT 1 FROM sys.tables t 
	JOIN sys.schemas s ON t.schema_id = s.schema_id 
	WHERE t.name = N'TEMP_PATTERNCARD_IDS' 
	AND s.name = N'dbo' 
) BEGIN DROP TABLE dbo.[TEMP_PATTERNCARD_IDS] END
GO--

CREATE TABLE ${items}.[dbo].[TEMP_PATTERNCARD_IDS](
	[PatternCardId] [uniqueidentifier] NOT NULL
	,[ProfileId] [uniqueidentifier] 
)
GO--

------ DROP AND CREATE PROFILE, PROFILEKEY AND PATTERNCARD TABLE FROM WAREHOUSE -------------------------------

USE ${warehouse}

IF EXISTS ( 
	SELECT 1 FROM sys.tables t 
	JOIN sys.schemas s ON t.schema_id = s.schema_id 
	WHERE t.name = N'IT_Profiles' 
	AND s.name = N'dbo' 
) BEGIN DROP TABLE dbo.[IT_Profiles] END
GO--

CREATE TABLE ${warehouse}.[dbo].[IT_Profiles](
	[ProfileId] [uniqueidentifier] NOT NULL
	,[ProfileName] [varchar](max)
)
GO--

IF EXISTS ( 
	SELECT 1 FROM sys.tables t 
	JOIN sys.schemas s ON t.schema_id = s.schema_id 
	WHERE t.name = N'IT_ProfileKeys' 
	AND s.name = N'dbo' 
) BEGIN DROP TABLE dbo.[IT_ProfileKeys] END
GO--

CREATE TABLE ${warehouse}.[dbo].[IT_ProfileKeys](
	[ProfileKeyId] [uniqueidentifier] NOT NULL
	,[ProfileId] [uniqueidentifier]
	,[ProfileKeyName] [varchar](max)
)
GO--

IF EXISTS ( 
	SELECT 1 FROM sys.tables t 
	JOIN sys.schemas s ON t.schema_id = s.schema_id 
	WHERE t.name = N'IT_PatternCards' 
	AND s.name = N'dbo' 
) BEGIN DROP TABLE dbo.[IT_PatternCards] END
GO--

CREATE TABLE ${warehouse}.[dbo].[IT_PatternCards](
	[PatternCardId] [uniqueidentifier] NOT NULL
	,[ProfileId] [uniqueidentifier]
	,[PatternCardName] [varchar](max)
)
GO--

------ INSERT PROFILE, PROFILEKEY AND PATTERNCARD IDS INTO MASTER -------------------------------

INSERT INTO ${items}.[dbo].[TEMP_PROFILE_IDS]
SELECT DISTINCT(ps.[ProfileId]) 
FROM ${warehouse}.[dbo].[IF_ProfileScores] ps 
WHERE ps.[ProfileId] IS NOT NULL
UNION
SELECT DISTINCT(cbp.[ProfileId]) 
FROM ${warehouse}.[dbo].[CF_ContactBehaviorProfiles] cbp 
WHERE cbp.[ProfileId] IS NOT NULL
GO--

INSERT INTO ${items}.[dbo].[TEMP_PROFILEKEY_IDS]
SELECT DISTINCT([ProfileKeyId]), ProfileId 
FROM ${warehouse}.[dbo].[IF_ProfileScores] 
WHERE [ProfileKeyId] IS NOT NULL 
GROUP BY ProfileId, ProfileKeyId
UNION ALL
SELECT DISTINCT(cbp.[ProfileKeyId]), ProfileId 
FROM ${warehouse}.[dbo].[CF_ContactBehaviorProfiles] cbp 
WHERE cbp.[ProfileKeyId] IS NOT NULL 
GROUP BY ProfileId, ProfileKeyId
GO--

INSERT INTO ${items}.[dbo].[TEMP_PATTERNCARD_IDS]
SELECT DISTINCT([PatternCardId]), ProfileId 
FROM ${warehouse}.[dbo].[IF_ProfileScores] 
WHERE [PatternCardId] IS NOT NULL 
GROUP BY ProfileId, PatternCardId
UNION ALL
SELECT DISTINCT(cbp.[PatternCardId]), ProfileId
FROM ${warehouse}.[dbo].[CF_ContactBehaviorProfiles] cbp 
WHERE cbp.[PatternCardId] IS NOT NULL
GROUP BY ProfileId, PatternCardId
GO--

------ INSERT PROFILE, PROFILEKEY AND PATTERNCARD IDS AND NAMES INTO WAREHOUSE -------------------------------

INSERT INTO ${warehouse}.[dbo].[IT_Profiles]
SELECT 
	p.[ProfileId]
	,i.Name
FROM ${items}.[dbo].[TEMP_PROFILE_IDS] p
LEFT JOIN ${items}.[dbo].[Items] i on i.ID = p.ProfileId
GO--

INSERT INTO ${warehouse}.[dbo].[IT_ProfileKeys]
SELECT 
	pk.[ProfileKeyId]
	,pk.[ProfileId]
	,i.Name
FROM ${items}.[dbo].[TEMP_PROFILEKEY_IDS] pk
LEFT JOIN ${items}.[dbo].[Items] i on i.ID = pk.ProfileKeyId
GO--

INSERT INTO ${warehouse}.[dbo].[IT_PatternCards]
SELECT 
	pc.[PatternCardId]
	,pc.[ProfileId]
	,i.Name
FROM ${items}.[dbo].[TEMP_PATTERNCARD_IDS] pc
LEFT JOIN ${items}.[dbo].[Items] i on i.ID = pc.PatternCardId
GO--

------ DROP PROFILE, PROFILEKEY AND PATTERNCARD TABLE FROM MASTER -------------------------------
DROP TABLE ${items}.[dbo].[TEMP_PROFILE_IDS]
GO--

DROP TABLE ${items}.[dbo].[TEMP_PROFILEKEY_IDS]
GO--

DROP TABLE ${items}.[dbo].[TEMP_PATTERNCARD_IDS]
GO--