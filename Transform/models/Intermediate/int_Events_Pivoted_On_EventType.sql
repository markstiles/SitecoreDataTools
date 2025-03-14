
with 

EventItems as (
	select
        ie.InteractionId
        ,ie.EventType
		,1 as NumValue
    from {{ ref('int_Events') }} as ie
)

select 
    type_sums.*
    ,case 
        when type_sums.[Goal] > 0 
        then 1
        else 0
    end as [CompletedGoal]
    ,case 
        when type_sums.[PersonalizationEvent] > 0 
        then 1
        else 0
    end as [IsPersonalized]
    ,case 
        when type_sums.[CampaignEvent] > 0 
        then 1
        else 0
    end as [SawCampaign]
from EventItems as src
PIVOT (
    sum(src.NumValue)
    FOR EventType IN ([CampaignEvent],[ChangeProfileScoresEvent],[Error],[GenericEvent],[Goal],[MVTestTriggered],[PageViewEvent],[PersonalizationEvent])
) as type_sums