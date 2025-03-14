
select 
    ie.[InteractionEventId]
    ,ie.[InteractionId]
    ,ie.[ContactId]
    ,ie.[Referrer]
from {{ ref('int_Events') }} as ie