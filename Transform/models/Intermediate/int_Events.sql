
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
    ,FORMAT(ie.[Timestamp], 'yyyy-MM') AS TimestampSortDate
    ,ie.[ItemLanguage]
    ,ie.[Text]
    ,ie.[EngagementValue]
    ,ie.[UserAgent]
    ,uai.[DeviceType] as Device
    ,wv.[Browser]
    ,case
        when ie.[UserAgent] like '%Android%' then 'Android'
        when ie.[UserAgent] like '%iOS%' then 'iOS'
        when ie.[UserAgent] like '%Windows%' then 'Windows'
        when ie.[UserAgent] like '%Chrome OS%' then 'Chrome OS'
        when ie.[UserAgent] like '%Mac OS%' then 'Mac OS'
        when ie.[UserAgent] like '%Linux%' then 'Linux'
        else 'Other'
    end as OS
    ,wv.[Referrer]
    ,wv.[SearchKeywords]
    ,wv.[IsSelfReferrer]
    ,itp.[PageName]
    ,itp.[TemplateName]
    ,itg.[GoalName]
    ,case 
        when itc.[CampaignName] is not null
        then itc.[CampaignName]
        else cast(ie.[CampaignId] as varchar(max))
    end as [CampaignName]
from {{ ref('stg_I_Events') }} as ie
left join {{ ref('stg_IF_UserAgentInfo') }} uai on uai.InteractionId = ie.InteractionId
left join {{ ref('stg_IF_WebVisits') }} wv on wv.InteractionId = ie.InteractionId
left join {{ ref('stg_IT_Campaigns') }} itc on itc.CampaignId = ie.CampaignId
left join {{ ref('stg_IT_Pages') }} itp on itp.PageId = ie.ItemId
left join {{ ref('stg_IT_Goals') }} itg on itg.GoalId = ie.DefinitionId