
SET ANSI_NULLS ON
GO--

SET QUOTED_IDENTIFIER ON
GO--

------ DROP AND CREATE GOAL TABLE FROM MASTER -------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'${warehouse}.[dbo].[IE_Delta]') AND type = 'U')
DROP TABLE ${warehouse}.[dbo].[IE_Delta]

CREATE TABLE ${warehouse}.[dbo].[IE_Delta](
	[InteractionEventId] [uniqueidentifier] NOT NULL
	,[ProfileId] [uniqueidentifier] NOT NULL
	,[ScoreCount] [int] NOT NULL
	,[ProfileKeyId] [uniqueidentifier] NOT NULL
	,[ProfileKeyValue] [float] NOT NULL
)
GO--

------ ADD TABLE DATA ------------------------------------------

INSERT INTO ${warehouse}.[dbo].[IE_Delta]
SELECT 
	ie.[InteractionEventId]
	,er.ProfileId
	,er.ScoreCount
	,iv.ProfileKeyId
	,iv.ProfileKeyValue
FROM ${warehouse}.[dbo].[I_Events] ie
cross apply openjson(ie.Delta) with (
	ProfileId uniqueidentifier '$.Key'
	,ScoreCount int '$.Value.ScoreCount'
	,InnerValues nvarchar(max) '$.Value.Values' as json
) er
cross apply openjson(er.InnerValues) with (
	ProfileKeyId uniqueidentifier '$.Key'
	,ProfileKeyValue float '$.Value'
) iv
WHERE ie.[Delta] IS NOT NULL

GO--