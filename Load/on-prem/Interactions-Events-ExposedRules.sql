
SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

------ DROP AND CREATE GOAL TABLE FROM MASTER -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[IE_ExposedRules]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[IE_ExposedRules]

CREATE TABLE ${warehouse}.[dbo].[IE_ExposedRules](
	[InteractionEventId] [uniqueidentifier] NOT NULL
	,[RuleId] [uniqueidentifier] NULL
	,[RuleSetId] [uniqueidentifier] NULL
	,[IsOriginal] [bit] NULL
)
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[IE_ExposedRules]
SELECT 
	ie.[InteractionEventId]
	,er.RuleId
	,er.RuleSetId
	,er.IsOriginal
FROM ${warehouse}.[dbo].[I_Events] ie
CROSS APPLY OPENJSON(ie.ExposedRules) WITH (
	RuleId uniqueidentifier '$.RuleId'
	,RuleSetId uniqueidentifier '$.RuleSetId'
	,IsOriginal bit '$.IsOriginal'
) er
WHERE ie.[ExposedRules] IS NOT NULL

GO--