
with 

InteractionCounts as (
    select e.ContactId, count(distinct e.InteractionId) as InteractionCount
    from {{ ref('int_Events') }} e
    group by e.ContactId, cast(e.Timestamp as date)
)

,MaxInteractionsPerDay as (
    select ContactId, max(InteractionCount) as MaxInteractionsPerDay
    from InteractionCounts
    group by ContactId
)

,ContactEvents as (
    select
        etpv.ContactId
        ,max(etpv.PagesPerMinute) as MaxPagesPerMinute
        ,sum(etpv.CampaignEvent) as CampaignEvents
        ,sum(etpv.ChangeProfileScoresEvent) as ChangeProfileScores
        ,sum(etpv.Error) as Errors
        ,sum(etpv.GenericEvent) as GenericEvents
        ,sum(etpv.Goal) as Goals
        ,sum(etpv.MVTestTriggered) as MVTestsTriggered
        ,sum(etpv.PageViewEvent) as PagesViewed
        ,sum(etpv.PersonalizationEvent) as PersonalizationEvents

    from {{ ref('int_Events_Joins_EventTypeSums_And_PageViewAggregates') }} etpv
    group by etpv.ContactId
)

select
    eac.ContactId
    ,eac.InteractionCount
    ,eac.TotalEngagementValue
    ,eac.ItemCount
    ,eac.FirstVisit
    ,eac.LastVisit
    ,eac.CampaignCount as CampaignsSeen
    ,mipd.MaxInteractionsPerDay
    ,ce.MaxPagesPerMinute
    ,ce.CampaignEvents
    ,ce.ChangeProfileScores
    ,ce.Errors
    ,ce.GenericEvents
    ,ce.Goals
    ,ce.MVTestsTriggered
    ,ce.PagesViewed
    ,ce.PersonalizationEvents

    -- Lifetime in days (fractional)
    ,cast(datediff(second, eac.FirstVisit, eac.LastVisit) as float) / 86400.0 as Lifetime

    -- VisitFrequency = InteractionCount / Lifetime, avoid divide-by-zero
    ,case when datediff(second, eac.FirstVisit, eac.LastVisit) = 0
         then 0
         else eac.InteractionCount 
              / (cast(datediff(second, eac.FirstVisit, eac.LastVisit) as float) / 86400.0)
    end as VisitFrequency
    -- "visits per day," "visits per week," or "visits per month
    -- recency is measured in days
    ,case when em.PreferredEmail is not null
        then 1
		else 0
    end as KnownContact
from {{ ref('int_Events_Aggregated_By_ContactId') }} as eac
left join ContactEvents ce on eac.ContactId = ce.ContactId
left join MaxInteractionsPerDay mipd on eac.ContactId = mipd.ContactId
left join {{ ref('stg_CF_Emails') }} em on eac.ContactId = em.ContactId