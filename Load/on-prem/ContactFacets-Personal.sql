
------ DROP THE TABLE AND CONSTRAINTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_CF_Personals]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[CF_Personals]
DROP CONSTRAINT [PK_CF_Personals]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[CF_Personals]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[CF_Personals]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [CF_Personals](
	[PersonalId] [uniqueidentifier] NOT NULL
	,[ContactId] [uniqueidentifier] NULL
    ,[FirstName] [nvarchar](255)
	,[LastName] [nvarchar](255)
	,[Suffix] [nvarchar](255)
 CONSTRAINT [PK_CF_Personals] PRIMARY KEY CLUSTERED 
(
	[PersonalId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[CF_Personals]
SELECT 
	NEWID()
	,cf.ContactId
	,f.FirstName
	,f.LastName
	,f.Suffix
FROM ${shard0}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	FirstName nvarchar(255) '$.FirstName'
	,LastName nvarchar(255) '$.LastName'
	,Suffix nvarchar(255) '$.Suffix'
) f
WHERE cf.FacetKey = 'Personal'

INSERT INTO ${warehouse}.[dbo].[CF_Personals]
SELECT 
	NEWID()
	,cf.ContactId
	,f.FirstName
	,f.LastName
	,f.Suffix
FROM ${shard1}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	FirstName nvarchar(255) '$.FirstName'
	,LastName nvarchar(255) '$.LastName'
	,Suffix nvarchar(255) '$.Suffix'
) f
WHERE cf.FacetKey = 'Personal'