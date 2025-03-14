
select 
    ie.[InteractionEventId]
    ,ie.[InteractionId]
    ,ie.[ContactId]
    ,ie.[SearchKeywords]
from {{ ref('int_Events') }} as ie