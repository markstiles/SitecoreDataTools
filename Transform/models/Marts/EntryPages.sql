with OrderedPages as (
	select
		[InteractionId]
        ,[PageName]
		,[ItemId]
	    ,ROW_NUMBER() over (partition by [InteractionId] order by Timestamp) as PageOrder
    from {{ ref('int_Events') }}
    where [PageName] is not null
    group by [InteractionId], [Timestamp], [PageName], [ItemId]
)

select
	[PageName]
	,[ItemId]
	,count(PageName) as EntryCount
from OrderedPages 
where [PageOrder] = 1
group by [PageName], [ItemId]