
SELECT
    ie.[InteractionEventId]
    ,ie.[InteractionId]
    ,ie.[ContactId]
    ,ie.[DeviceProfileId]
    ,ie.[CampaignId]
    ,ie.[CampaignDefinitionId]
    ,ie.[DefinitionId]
    ,ie.[ItemId]
    ,ie.[Timestamp]
    ,ie.[ItemLanguage]
    ,ie.[Text]
    ,ie.[EngagementValue]
    ,ie.[Device]
    ,ie.[Browser]
    ,ie.[OS]
    ,ie.[Referrer]
    ,ie.[SearchKeywords]
    ,ie.[IsSelfReferrer]
    ,ie.PageName
    ,ie.TemplateName
    ,CASE 
		WHEN LEAD(Timestamp) OVER (PARTITION BY InteractionId ORDER BY Timestamp) Is Not Null 
			Then DATEDIFF(
				SECOND, 
				Timestamp, 
				LEAD(Timestamp) OVER (PARTITION BY InteractionId ORDER BY Timestamp)
			) / 60.0
		ELSE NULL
    END as ReadTime
from {{ ref('int_Events') }} as ie
where ie.EventType = 'PageViewEvent'