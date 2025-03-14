
SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

------ DROP AND CREATE GOAL TABLE FROM MASTER -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${items}.[dbo].[TEMP_GOAL_IDS]') AND type = 'U')
DROP TABLE ${items}.[dbo].[TEMP_GOAL_IDS]

CREATE TABLE ${items}.[dbo].[TEMP_GOAL_IDS](
	[GoalId] [uniqueidentifier] NOT NULL
)
GO--

------ DROP AND CREATE GOAL TABLE FROM WAREHOUSE -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[IT_Goals]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[IT_Goals]

CREATE TABLE ${warehouse}.[dbo].[IT_Goals](
	[GoalId] [uniqueidentifier] NOT NULL
	,[GoalName] [varchar](max)
)
GO--

------ INSERT GOAL IDS INTO MASTER -------------------------------

INSERT INTO ${items}.[dbo].[TEMP_GOAL_IDS]
SELECT DISTINCT (DefinitionId) FROM ${warehouse}.[dbo].[I_Events] WHERE DefinitionId IS NOT NULL
GO--

------ INSERT GOAL IDS AND NAMES INTO WAREHOUSE -------------------------------

INSERT INTO ${warehouse}.[dbo].[IT_Goals]
SELECT 
	g.GoalId
	,i.Name
FROM ${items}.[dbo].[TEMP_GOAL_IDS] g
LEFT JOIN ${items}.[dbo].[Items] i on i.ID = g.GoalId
GO--

------ DROP GOAL TABLE FROM MASTER -------------------------------
DROP TABLE ${items}.[dbo].[TEMP_GOAL_IDS]
GO--