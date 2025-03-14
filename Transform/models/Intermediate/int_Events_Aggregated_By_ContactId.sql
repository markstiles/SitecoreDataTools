
select
    ie.ContactId
    ,COUNT(distinct ie.InteractionId) as InteractionCount
    ,SUM(ie.EngagementValue)          as TotalEngagementValue
    ,COUNT(distinct ie.ItemId)        as ItemCount
    ,MIN(ie.[Timestamp])              as FirstVisit
    ,MAX(ie.[Timestamp])              as LastVisit
    ,COUNT(distinct ie.CampaignId)    as CampaignCount
from {{ ref('int_Events') }} as ie
group by ie.ContactId