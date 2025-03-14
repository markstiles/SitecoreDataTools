
select * 
from {{ source('analytics','CF_Emails') }} as em
where em.PreferredEmail is not null