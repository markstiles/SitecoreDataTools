
SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

------ DROP AND CREATE PAGE TABLE FROM MASTER -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${items}.[dbo].[TEMP_PAGE_IDS]') AND type = 'U')
DROP TABLE ${items}.[dbo].[TEMP_PAGE_IDS]

CREATE TABLE ${items}.[dbo].[TEMP_Page_IDS](
	[PageId] [uniqueidentifier] NOT NULL
)
GO--

------ DROP AND CREATE PAGE TABLE FROM WAREHOUSE -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[IT_Pages]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[IT_Pages]

CREATE TABLE ${warehouse}.[dbo].[IT_Pages](
	[PageId] [uniqueidentifier] NOT NULL
	,[PageName] [varchar](max)
	,[TemplateName] [varchar](max)
)
GO--

------ INSERT PAGE IDS INTO MASTER -------------------------------

INSERT INTO ${items}.[dbo].[TEMP_PAGE_IDS]
SELECT DISTINCT (ItemId) FROM ${warehouse}.[dbo].[I_Events] WHERE ItemId IS NOT NULL
GO--

------ INSERT PAGE IDS AND NAMES INTO WAREHOUSE -------------------------------

INSERT INTO ${warehouse}.[dbo].[IT_Pages]
SELECT 
	p.PageId
	,i.Name
	,t.Name
FROM ${items}.[dbo].[TEMP_PAGE_IDS] p
LEFT JOIN ${items}.[dbo].[Items] i on i.ID = p.PageId
LEFT JOIN ${items}.[dbo].[Items] t on t.ID = i.TemplateID
GO--

------ DROP PAGE TABLE FROM MASTER -------------------------------
DROP TABLE ${items}.[dbo].[TEMP_PAGE_IDS]
GO--