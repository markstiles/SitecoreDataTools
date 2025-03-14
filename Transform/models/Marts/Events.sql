
select 
    ie.[InteractionEventId]
    ,ie.[InteractionId]
    ,ie.[ContactId]
    ,ie.[EventType]
    ,ie.[Timestamp]
    ,ie.[EngagementValue]
from {{ ref('int_Events') }} as ie