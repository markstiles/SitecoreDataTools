
with 

PageViewAggregates as (
    select
        e.InteractionId
        ,e.ContactId
        ,round((cast(datediff(second, min(e.[Timestamp]), max(e.[Timestamp])) as float) / 60.0), 2) as PageDuration
        ,case 
            when datediff(second, min(e.[Timestamp]), max(e.[Timestamp])) < 1
                then 0
            else datediff(second, min(e.[Timestamp]), max(e.[Timestamp]))
        end as PageDurationInSeconds
        ,count(distinct e.ItemId) as ItemCount
    from {{ ref('int_Events') }} e
    where e.EventType = 'PageViewEvent'
    group by e.InteractionId, e.ContactId
)

select * from PageViewAggregates