
SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

------ DROP AND CREATE GOAL TABLE FROM MASTER -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[IE_EligibleRules]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[IE_EligibleRules]

CREATE TABLE ${warehouse}.[dbo].[IE_EligibleRules](
	[InteractionEventId] [uniqueidentifier] NOT NULL
	,[RuleId] [uniqueidentifier] NOT NULL
)
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[IE_EligibleRules]
SELECT 
	ie.[InteractionEventId]
	,cast(er.Value as uniqueidentifier)
FROM ${warehouse}.[dbo].[I_Events] ie
CROSS APPLY OPENJSON(ie.EligibleRules, '$') er
WHERE ie.[EligibleRules] IS NOT NULL
AND er.Value != '00000000-0000-0000-0000-000000000000'

GO--