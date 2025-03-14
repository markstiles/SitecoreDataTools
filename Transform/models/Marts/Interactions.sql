
with 

Duration as (
    select
        e.InteractionId
        ,COUNT(e.InteractionEventId) as EventCount
        ,MIN(e.[Timestamp]) as DateMin
        ,MAX(e.[Timestamp]) as DateMax
        ,e.[ContactId] as ContactId
        
        -- Duration in minutes
        ,DATEDIFF(minute, MIN(e.[Timestamp]), MAX(e.[Timestamp])) as InteractionDuration

		-- Total engagement value
		,SUM(e.[EngagementValue]) as EngagementValue
    from {{ ref('int_Events') }} e
    group by e.InteractionId, e.ContactId
)

, Interactions as (
	select 
		ippm.*
		,d.EventCount
		,d.InteractionDuration
		,d.DateMin as Timestamp
		,case
			when d.DateMin = eac.FirstVisit
			then 1
			else 0
		end as FirstInteraction
		,d.EngagementValue
	from {{ ref('int_Events_Joins_EventTypeSums_And_PageViewAggregates') }} ippm
	left join Duration d on ippm.InteractionId = d.InteractionId
	left join {{ ref('int_Events_Aggregated_By_ContactId') }} eac on eac.ContactId = d.ContactId
) 

select * from Interactions