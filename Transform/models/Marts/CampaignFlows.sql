with SkipDuplicatePages as (
	SELECT 
		InteractionId
		,ItemId
		,PageName
		,CampaignId
		,Timestamp
		,case WHEN LEAD(ItemId) OVER (PARTITION BY InteractionId ORDER BY Timestamp ASC) = ItemId
			THEN COALESCE(LEAD(ReadTime) OVER (PARTITION BY InteractionId ORDER BY Timestamp ASC), 0) + COALESCE(ReadTime, 0)
			ELSE ReadTime
		END AS ReadTime
		,case WHEn LAG(ItemId) OVER (PARTITION BY InteractionId ORDER BY Timestamp ASC) = ItemId
			THEN 1
			ELSE 0
		END AS Hide
	FROM {{ ref('PageViews') }}
	WHERE PageName IS NOT NULL AND CampaignId IS NOT NULL
)
,RankedPages AS (
    SELECT 
        Distinct
		ItemId
		,PageName
        ,ROW_NUMBER() OVER (ORDER BY PageName) AS PageOrder
    FROM {{ ref('PageViews') }}
	WHERE PageName IS NOT NULL
	GROUP BY ItemId, PageName
)
,CampaignFlows AS (
    SELECT 
        r1.InteractionId,
		r1.ItemId,
        r1.PageName,
		r1.ReadTime,
		r2.PageOrder as Source,
		LEAD(r2.PageOrder) OVER (PARTITION BY r1.InteractionId ORDER BY r1.Timestamp ASC) as Target,
		Timestamp,
		CampaignId
    FROM SkipDuplicatePages r1
    LEFT JOIN RankedPages r2 ON r1.ItemId = r2.ItemId
	WHERE r1.Hide = 0
	GROUP BY r1.InteractionId, r1.ItemId, r1.PageName, r1.ReadTime, PageOrder, Timestamp, CampaignId
)

select * from CampaignFlows