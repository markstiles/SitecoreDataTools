
------ DROP THE TABLE AND CONSTRAINTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_CF_Classifications]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[CF_Classifications]
DROP CONSTRAINT [PK_CF_Classifications]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[CF_Classifications]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[CF_Classifications]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [CF_Classifications](
	[ClassificationId] [uniqueidentifier] NOT NULL
	,[ContactId] [uniqueidentifier] NULL
    ,[ClassificationLevel] [int]
 CONSTRAINT [PK_CF_Classifications] PRIMARY KEY CLUSTERED 
(
	[ClassificationId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[CF_Classifications]
SELECT 
	NEWID()
	,cf.ContactId
    ,f.ClassificationLevel
FROM ${shard0}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	ClassificationLevel int '$.ClassificationLevel'
) f
WHERE cf.FacetKey = 'Classification'

INSERT INTO ${warehouse}.[dbo].[CF_Classifications]
SELECT 
	NEWID()
	,cf.ContactId
    ,f.ClassificationLevel
FROM ${shard1}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	ClassificationLevel int '$.ClassificationLevel'
) f
WHERE cf.FacetKey = 'Classification'