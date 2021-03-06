set pagesize 999
set lines 999
col username format a13
col program  format a10 trunc
col modules  format a10 trunc
col session_id format 9999
col session_serial# format 99999

select *
from (
select username, sql_id, SQL_CHILD_NUMBER, count(*)
from (
select sample_time , c.username, SESSION_ID, SESSION_SERIAL#, INST_ID, PROGRAM,module, IS_AWR_SAMPLE, a.sql_id, SQL_CHILD_NUMBER, IS_SQLID_CURRENT, 
    SESSION_STATE, WAIT_TIME, WAIT_CLASS, EVENT, P1TEXT, P2TEXT, P3TEXT,  TIME_WAITED/100 time_waited_secs,
    BLOCKING_SESSION, BLOCKING_SESSION_SERIAL#, BLOCKING_INST_ID  
from gv$active_session_history a, 
 dba_users c
where 
a.user_id = c.user_id 
)
where  wait_class <> 'User I/O' and  session_state= 'WAITING' and WAIT_TIME = 0
and SAMPLE_TIME > sysdate - (&minutes_from_now/(24*60))
group by username, sql_id, SQL_CHILD_NUMBER
order by count(*) desc
)
where rownum < 101
/