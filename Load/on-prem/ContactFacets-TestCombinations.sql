
------ DROP THE TABLE AND CONSTRAINTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_CF_TestCombinations]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[CF_TestCombinations]
DROP CONSTRAINT [PK_CF_TestCombinations]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[CF_TestCombinations]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[CF_TestCombinations]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [CF_TestCombinations](
	[TestCombinationId] [uniqueidentifier] NOT NULL
	,[ContactId] [uniqueidentifier] NULL
	,[TestCombinations] [nvarchar](max)
 CONSTRAINT [PK_CF_TestCombinations] PRIMARY KEY CLUSTERED 
(
	[TestCombinationId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[CF_TestCombinations]
SELECT 
	NEWID()
	,cf.ContactId
	,f.TestCombinations
FROM ${shard0}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	TestCombinations nvarchar(max) '$.TestCombinations'
) f
WHERE cf.FacetKey = 'TestCombinations'
AND len(f.TestCombinations) > 0

INSERT INTO ${warehouse}.[dbo].[CF_TestCombinations]
SELECT 
	NEWID()
	,cf.ContactId
	,f.TestCombinations
FROM ${shard1}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	TestCombinations nvarchar(max) '$.TestCombinations'
) f
WHERE cf.FacetKey = 'TestCombinations'
AND len(f.TestCombinations) > 0