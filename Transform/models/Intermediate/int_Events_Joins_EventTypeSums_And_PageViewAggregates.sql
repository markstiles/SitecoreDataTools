
with InteractionEventValues as (
	select 
		epe.*
		,pd.PageDuration
		,pd.PageDurationInSeconds
		,pd.ContactId
		,pd.ItemCount
		,case
			when pd.PageDuration = 0 

			-- If duration is 0, use the count
			then epe.PageViewEvent                          
			
			-- Otherwise divide by the duration
			else round(cast(epe.PageViewEvent AS FLOAT), 2) / pd.PageDuration                
		end as PagesPerMinute
		,case
			when pd.PageDurationInSeconds = 0 

			-- If duration is 0, use the count
			then epe.PageViewEvent                          
			
			-- Otherwise divide by the duration
			else round(cast(epe.PageViewEvent AS FLOAT), 3) / pd.PageDurationInSeconds       
		end as PagesPerSecond		
	from {{ ref('int_Events_Pivoted_On_EventType') }} epe
	left join {{ ref('int_Events_Aggregated_By_InteractionId_Filtered_By_PageViewEvent') }} pd on epe.InteractionId = pd.InteractionId
) 

select * from InteractionEventValues