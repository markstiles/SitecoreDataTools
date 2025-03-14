
SELECT
    ie.[InteractionEventId]
    ,ie.[InteractionId]
    ,ie.[ContactId]
    ,ie.[DeviceProfileId]
    ,ie.[CampaignId]
    ,ie.[CampaignDefinitionId]
    ,ie.[EventType]
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
from {{ ref('int_Events') }} as ie
where ie.EventType = 'PageViewEvent'