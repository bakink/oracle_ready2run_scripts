-----------------------------------------------------------------------------
--	Find OWB nodes (mappings or procedures) that are waiting on a lock (wait classes: application or concurrecy or configuration)
--	from GV$SESSION for more that 15 minutes.
-----------------------------------------------------------------------------
col sw_event  head EVENT for a40 truncate
col state format a10
col username format a13
col prog format a30 trunc
col sql_text format a130 trunc
col prev_sql_text format a130 trunc
col sid format 9999
col child for 99999
col avg_etime_secs for 999999,999.99
col wait_status for a21
col event format a30 trunc
col wait_class format a12
col blocking_instance format 9999999999999999
col blocking_session format 9999999999999999
col sql_id format a20
col prev_sql_id format a20
break on sql_id
compute COUNT LABEL TotalSessions OF distinct sid on sql_id

col owb_exec_audit_id format a10
col owb_execution_name_short format a30 trunc
col main_flow format a20 trunc
col	owb_type format a10 trunc
col owb_status format a10 trunc
col owb_result format a10 trunc

select  username, sid, serial#, INST_ID, logon_time,
        owb_exec_audit_id, owb_execution_name_short owb_node_name, main_flow, owb_type, owb_status, owb_result, owb_created_on, owb_updated_on,  
        status session_status, wait_class, event, round(seconds_in_wait/60) mins_in_wait, wait_status,
        blocking_instance, blocking_session, owner, object_name, object_type,
        sql_id, sql_text    
from
(
    SELECT username, sid, serial#, a.INST_ID,
         -- include info from OWB executions
            a.client_info owb_exec_audit_id, 
            (select SUBSTR (execution_name, INSTR (execution_name, ':') + 1) from owbsys.all_rt_audit_executions where execution_audit_id = a.client_info) owb_execution_name_short,
            (select execution_name from owbsys.all_rt_audit_executions where execution_audit_id = (select top_level_execution_audit_id from owbsys.all_rt_audit_executions  where execution_audit_id = a.client_info)) main_flow,            
            (select DECODE (task_type,'PLSQL', 'Mapping','PLSQLProcedure', 'Procedure', 'PLSQLFunction', 'Function') TYPE from owbsys.all_rt_audit_executions where execution_audit_id = a.client_info) owb_type, 
            (select execution_audit_status from owbsys.all_rt_audit_executions where execution_audit_id = a.client_info) owb_status, 
            (select return_result from owbsys.all_rt_audit_executions where execution_audit_id = a.client_info) owb_result, 
            (select created_on from owbsys.all_rt_audit_executions where execution_audit_id = a.client_info) owb_created_on, 
            (select updated_on from owbsys.all_rt_audit_executions where execution_audit_id = a.client_info)owb_updated_on,
            /*(select SYS_CONNECT_BY_PATH (SUBSTR (execution_name, INSTR (execution_name, ':') + 1),'/')
                from owbsys.all_rt_audit_executions 
                where execution_audit_id = a.client_info
                START WITH  PARENT_EXECUTION_AUDIT_ID IS NULL
                CONNECT BY PRIOR execution_audit_id = parent_execution_audit_id
            ) owb_path,*/  
         a.status, WAIT_CLASS, EVENT,SECONDS_IN_WAIT, DECODE (WAIT_TIME, 0, 'Currently Waiting', WAIT_TIME) wait_status, --WAIT_TIME_MICRO/10e6 WAIT_TIME_SECS,
         a.logon_time,program prog, machine,    --address, hash_value,
         a.sql_id, a.sql_child_number child, a.sql_hash_value,
         b.executions execs, (b.elapsed_time / DECODE (NVL (b.executions, 0), 0, 1, b.executions))/ 1000000 avg_etime_secs,
         b.sql_text,
         a.prev_sql_id,
         a.prev_child_number prev_child,
         a.prev_hash_value,
         b2.executions execs, (  b2.elapsed_time/ DECODE (NVL (b2.executions, 0), 0, 1, b2.executions)) / 1000000  avg_etime_secs,
         b2.sql_text prev_sql_text,
         blocking_instance,
         blocking_session,
         c.owner,
         c.object_name,
         c.object_type
    FROM gv$session a,
         gv$sql b,
         gv$sql b2,
         dba_objects c --owbsys.all_rt_audit_executions d         
    WHERE  1=1
		AND	username in ('PERIF', 'ETL_DW','OWF_MGR', 'MIS')         
        AND (    a.sql_id = b.sql_id(+)
              AND A.SQL_CHILD_NUMBER  = b.child_number(+)
              AND a.inst_id = b.inst_id(+))
         AND (    a.prev_sql_id = b2.sql_id(+)
              AND a.prev_child_number = b2.child_number(+)
              AND a.inst_id = b2.inst_id(+))
         AND a.ROW_WAIT_OBJ# = c.OBJECT_ID(+) 
    -- and sql_text not like 'select username, sid, serial#, a.INST_ID, a.status, program prog, machine, address, hash_value, b.sql_id, child_number child,%' -- don't show this query
) 
where 1=1
	and wait_status = 'Currently Waiting'
    and wait_class in ('Application', 'Concurrency', 'Configuration') 
	and seconds_in_wait > 10*60
ORDER BY seconds_in_wait desc, username, sql_id
/


