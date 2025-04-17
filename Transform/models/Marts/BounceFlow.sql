with BaseFlow as (
	select
		[FirstInteraction] as Source
		,case 
			when [PageViewEvent] > 1
			then 2
			else 3
		end as Target
	from {{ ref('Interactions') }}
)

select
	[Source]
	,[Target]
	,count([Source]) as Value
from BaseFlow
group by [Source], [Target]