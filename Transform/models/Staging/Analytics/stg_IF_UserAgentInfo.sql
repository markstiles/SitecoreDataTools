
select * from {{ source('analytics','IF_UserAgentInfo') }}