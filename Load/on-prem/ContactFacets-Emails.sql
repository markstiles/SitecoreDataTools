
------ DROP THE TABLE AND CONSTRAINTS -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PK_CF_Emails]') AND type = 'PK')
ALTER TABLE ${warehouse}.[dbo].[CF_Emails]
DROP CONSTRAINT [PK_CF_Emails]
GO--

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[CF_Emails]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[CF_Emails]
GO--

------ CREATE TABLE ------------------------------------------

USE ${warehouse}
GO--

SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

CREATE TABLE [CF_Emails](
	[EmailId] [uniqueidentifier] NOT NULL
	,[ContactId] [uniqueidentifier] NULL
    ,[Others] [nvarchar](max)
	,[PreferredKey] [nvarchar](255)
	,[PreferredEmail] [nvarchar](max)
 CONSTRAINT [PK_CF_Emails] PRIMARY KEY CLUSTERED 
(
	[EmailId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[CF_Emails]
SELECT 
	NEWID()
	,cf.ContactId
	,f.Others
	,f.PreferredKey
	,f.PreferredEmail
FROM ${shard0}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	Others nvarchar(max) '$.Others' AS JSON
	,PreferredKey nvarchar(255) '$.PreferredKey'
	,PreferredEmail nvarchar(max) '$.PreferredEmail.SmtpAddress'
) f
WHERE cf.FacetKey = 'Emails'

INSERT INTO ${warehouse}.[dbo].[CF_Emails]
SELECT 
	NEWID()
	,cf.ContactId
	,f.Others
	,f.PreferredKey
	,f.PreferredEmail
FROM ${shard1}.[xdb_collection].[ContactFacets] cf
CROSS APPLY OPENJSON(cf.FacetData) WITH (
	Others nvarchar(max) '$.Others' AS JSON
	,PreferredKey nvarchar(255) '$.PreferredKey'
	,PreferredEmail nvarchar(max) '$.PreferredEmail.SmtpAddress'
) f
WHERE cf.FacetKey = 'Emails'