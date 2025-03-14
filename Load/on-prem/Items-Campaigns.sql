
SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

------ DROP AND CREATE CAMPAIGN TABLE FROM MASTER -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${items}.[dbo].[TEMP_CAMP_IDS]') AND type = 'U')
DROP TABLE ${items}.[dbo].[TEMP_CAMP_IDS]

CREATE TABLE ${items}.[dbo].[TEMP_CAMP_IDS](
	[CampaignId] [uniqueidentifier] NOT NULL
)
GO--

------ DROP AND CREATE CAMPAIGN TABLE FROM WAREHOUSE -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[IT_Campaigns]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[IT_Campaigns]

CREATE TABLE ${warehouse}.[dbo].[IT_Campaigns](
	[CampaignId] [uniqueidentifier] NOT NULL
	,[CampaignName] [varchar](max)
)
GO--

------ INSERT CAMPAIGN IDS INTO MASTER -------------------------------

INSERT INTO ${items}.[dbo].[TEMP_CAMP_IDS]
SELECT DISTINCT (CampaignId) FROM ${warehouse}.[dbo].[I_Events] WHERE CampaignId IS NOT NULL
GO--

------ INSERT CAMPAIGN IDS AND NAMES INTO WAREHOUSE -------------------------------

INSERT INTO ${warehouse}.[dbo].[IT_Campaigns]
SELECT 
	c.CampaignId
	,i.Name
FROM ${items}.[dbo].[TEMP_CAMP_IDS] c
LEFT JOIN ${items}.[dbo].[Items] i on i.ID = c.CampaignId
GO--

------ DROP CAMPAIGN TABLE FROM MASTER -------------------------------
DROP TABLE ${items}.[dbo].[TEMP_CAMP_IDS]
GO--