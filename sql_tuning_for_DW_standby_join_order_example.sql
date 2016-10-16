--0ny4qx6p8rdx0
SELECT /* LEADING(@"SEL$1" "DWH2_WCRM_ORDER_TYPE_DIM"@"SEL$1" "DWH2_WCRM_CONST_STATUS_DIM"@"SEL$1" "CONSTR_WCRM_FCT"@"SEL$1" "SOURCE_SYSTEMS_DIM"@"SEL$1" "DWH2_WCRM_ORIG_ORDER_TYPE_DIM"@"SEL$1"
         "DWH2_WCRM_DEKTIS_PROVIDER_DIM"@"SEL$1" "DWH2_WCRM_DOTIS_PROVIDER_DIM"@"SEL$1")*/ 
         --+ LEADING(DWH2_WCRM_ORDER_TYPE_DIM CONSTR_WCRM_FCT DWH2_WCRM_CONST_STATUS_DIM) */ 
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER,
  PRESENT_PERIF.CONSTR_WCRM_FCT.ORDER_ID,
  PRESENT_PERIF.CONSTR_WCRM_FCT.APPLICATION_DATE,
  PRESENT_PERIF.CONSTR_WCRM_FCT.UPDATE_DATE,
  PRESENT_PERIF.SOURCE_SYSTEMS_DIM.SOURCESYSTEM_DESCR,
  PRESENT_PERIF.CONSTR_WCRM_FCT.PHONE_NUMBER,
  ( DWH2_WCRM_DEKTIS_PROVIDER_DIM.SYSTEM_PROVIDER_DESCR ),
  ( DWH2_WCRM_DOTIS_PROVIDER_DIM.SYSTEM_PROVIDER_DESCR ),
  DWH2_WCRM_ORDER_TYPE_DIM.CONSTR_ORDER_DESC,
  DWH2_WCRM_ORIG_ORDER_TYPE_DIM.CONSTR_ORDER_DESC,
  DWH2_WCRM_CONST_STATUS_DIM.STATUS_NAME,
  DWH2_WCRM_CONST_STATUS_DIM.STATUS_CODE,
  DWH2_WCRM_CONST_STATUS_DIM.STATUS_DESCR,
  DWH2_WCRM_CONST_STATUS_DIM.STATUS_CUSTGROUP_DESCR,
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_STATUS_OTE,
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_REJECT_REASON,
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_LAST_MSG_DATE,
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_STATUS_SK_CC,
  case 
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'P%' then 'Portability'
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'D%' then 'Disconnection'
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'U%' then 'Update'
    else 'Undefined'
end,
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_PORTING_ID,
  Count(( PRESENT_PERIF.CONSTR_WCRM_FCT.APPLICATION_DATE_TRUNC )),
  PRESENT_PERIF.CONSTR_WCRM_FCT.CONNECTION_TYPE,
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_UNIQUE_ID,
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_LLU_ORDER_ID,
  PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_DATE_TRUNC,
  PRESENT_PERIF.CONSTR_WCRM_FCT.APPLICATION_DATE_TRUNC,
  ( DWH2_WCRM_DEKTIS_PROVIDER_DIM.PROVIDER_GLOBAL_DESCR )
FROM
  PRESENT_PERIF.CONSTR_WCRM_FCT,
  TARGET_DW.PROVIDER_DIM  DWH2_WCRM_DEKTIS_PROVIDER_DIM,
  TARGET_DW.PROVIDER_DIM  DWH2_WCRM_DOTIS_PROVIDER_DIM,
  PRESENT_PERIF.ORDER_ORDER_STATUS_DIM  DWH2_WCRM_CONST_STATUS_DIM,
  PRESENT_PERIF.CONSTR_ORDER_TYPE_DIM  DWH2_WCRM_ORDER_TYPE_DIM,
  PRESENT_PERIF.CONSTR_ORDER_TYPE_DIM  DWH2_WCRM_ORIG_ORDER_TYPE_DIM,
  PRESENT_PERIF.SOURCE_SYSTEMS_DIM
WHERE
  ( DWH2_WCRM_DEKTIS_PROVIDER_DIM.PROVIDER_SK=PRESENT_PERIF.CONSTR_WCRM_FCT.PROVIDER_SK  )
  AND  ( DWH2_WCRM_DOTIS_PROVIDER_DIM.PROVIDER_SK=PRESENT_PERIF.CONSTR_WCRM_FCT.PROVIDER_SK_OWN  )
  AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.SOURCESYSTEM_SK=PRESENT_PERIF.SOURCE_SYSTEMS_DIM.SOURCESYSTEM_SK  )
  AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.ORDER_STATUS_SK=DWH2_WCRM_CONST_STATUS_DIM.STATUS_SK  )
  AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_ORDER_SK_ORIG=DWH2_WCRM_ORIG_ORDER_TYPE_DIM.CONSTR_ORDER_SK  )
  AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_ORDER_SK=DWH2_WCRM_ORDER_TYPE_DIM.CONSTR_ORDER_SK  )
  AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.BUSINESS_SOURCE =  'WNP'  )
  AND  
  (
   case 
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'P%' then 'Portability'
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'D%' then 'Disconnection'
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'U%' then 'Update'
    else 'Undefined'
end  IN  ( 'Portability'  )
   AND
   PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_DATE_TRUNC  >=   date'2015-01-01' 
   AND
   DWH2_WCRM_CONST_STATUS_DIM.STATUS_CUSTGROUP_DESCR  IN  ( '������������'  )
  )
  AND DWH2_WCRM_ORDER_TYPE_DIM.CONSTR_ORDER_CODE in ('NP_EXTLLU')--'PRM_301', 'PRM_303')
GROUP BY
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.ORDER_ID, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.APPLICATION_DATE, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.UPDATE_DATE, 
  PRESENT_PERIF.SOURCE_SYSTEMS_DIM.SOURCESYSTEM_DESCR, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.PHONE_NUMBER, 
  ( DWH2_WCRM_DEKTIS_PROVIDER_DIM.SYSTEM_PROVIDER_DESCR ), 
  ( DWH2_WCRM_DOTIS_PROVIDER_DIM.SYSTEM_PROVIDER_DESCR ), 
  DWH2_WCRM_ORDER_TYPE_DIM.CONSTR_ORDER_DESC, 
  DWH2_WCRM_ORIG_ORDER_TYPE_DIM.CONSTR_ORDER_DESC, 
  DWH2_WCRM_CONST_STATUS_DIM.STATUS_NAME, 
  DWH2_WCRM_CONST_STATUS_DIM.STATUS_CODE, 
  DWH2_WCRM_CONST_STATUS_DIM.STATUS_DESCR, 
  DWH2_WCRM_CONST_STATUS_DIM.STATUS_CUSTGROUP_DESCR, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_STATUS_OTE, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_REJECT_REASON, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_LAST_MSG_DATE, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_STATUS_SK_CC, 
  case 
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'P%' then 'Portability'
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'D%' then 'Disconnection'
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'U%' then 'Update'
    else 'Undefined'
end, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_PORTING_ID, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.CONNECTION_TYPE, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_UNIQUE_ID, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.NP_LLU_ORDER_ID, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_DATE_TRUNC, 
  PRESENT_PERIF.CONSTR_WCRM_FCT.APPLICATION_DATE_TRUNC, 
  ( DWH2_WCRM_DEKTIS_PROVIDER_DIM.PROVIDER_GLOBAL_DESCR );

/*
--optimizer selected the following order

 LEADING(@"SEL$1" "DWH2_WCRM_ORDER_TYPE_DIM"@"SEL$1" "DWH2_WCRM_CONST_STATUS_DIM"@"SEL$1" "CONSTR_WCRM_FCT"@"SEL$1" "SOURCE_SYSTEMS_DIM"@"SEL$1" "DWH2_WCRM_ORIG_ORDER_TYPE_DIM"@"SEL$1"
         "DWH2_WCRM_DEKTIS_PROVIDER_DIM"@"SEL$1" "DWH2_WCRM_DOTIS_PROVIDER_DIM"@"SEL$1")
 USE_NL(@"SEL$5208623C" "DWH2_WCRM_CONST_STATUS_DIM"@"SEL$1")*/

SELECT ...
FROM
  PRESENT_PERIF.CONSTR_WCRM_FCT,
  TARGET_DW.PROVIDER_DIM  DWH2_WCRM_DEKTIS_PROVIDER_DIM,
  TARGET_DW.PROVIDER_DIM  DWH2_WCRM_DOTIS_PROVIDER_DIM,
  PRESENT_PERIF.ORDER_ORDER_STATUS_DIM  DWH2_WCRM_CONST_STATUS_DIM,
  PRESENT_PERIF.CONSTR_ORDER_TYPE_DIM  DWH2_WCRM_ORDER_TYPE_DIM,
  PRESENT_PERIF.CONSTR_ORDER_TYPE_DIM  DWH2_WCRM_ORIG_ORDER_TYPE_DIM,
  PRESENT_PERIF.SOURCE_SYSTEMS_DIM
WHERE
  ( DWH2_WCRM_DEKTIS_PROVIDER_DIM.PROVIDER_SK=PRESENT_PERIF.CONSTR_WCRM_FCT.PROVIDER_SK  )
  AND  ( DWH2_WCRM_DOTIS_PROVIDER_DIM.PROVIDER_SK=PRESENT_PERIF.CONSTR_WCRM_FCT.PROVIDER_SK_OWN  )
  AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.SOURCESYSTEM_SK=PRESENT_PERIF.SOURCE_SYSTEMS_DIM.SOURCESYSTEM_SK  )
  AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.ORDER_STATUS_SK=DWH2_WCRM_CONST_STATUS_DIM.STATUS_SK  )
  AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_ORDER_SK_ORIG=DWH2_WCRM_ORIG_ORDER_TYPE_DIM.CONSTR_ORDER_SK  )
  AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_ORDER_SK=DWH2_WCRM_ORDER_TYPE_DIM.CONSTR_ORDER_SK  )
  AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.BUSINESS_SOURCE =  'WNP'  )
  AND  
  (
   case 
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'P%' then 'Portability'
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'D%' then 'Disconnection'
    when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'U%' then 'Update'
    else 'Undefined'
end  IN  ( 'Portability'  )
   AND
   PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_DATE_TRUNC  >=  '01-01-2015 00:00:00'
   AND
   DWH2_WCRM_CONST_STATUS_DIM.STATUS_CUSTGROUP_DESCR  IN  ( '������������'  )
  )
  AND DWH2_WCRM_ORDER_TYPE_DIM.CONSTR_ORDER_CODE in ('PRM_301', 'PRM_303')
GROUP BY ...
        

-- filter ratios

with q1
as(
    select count(*) cnt 
    from PRESENT_PERIF.CONSTR_WCRM_FCT
    --824,776
    where
          case 
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'P%' then 'Portability'
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'D%' then 'Disconnection'
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'U%' then 'Update'
            else 'Undefined'
        end  IN  ( 'Portability'  )
           AND
           PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_DATE_TRUNC  >=  date'2015-01-01'     
),
q2 as(
    select count(*) cnt 
    from PRESENT_PERIF.CONSTR_WCRM_FCT
    --31,065,734
)
select q1.cnt/q2.cnt from q1,q2
-- 0,02


with q1
as(
    select count(*) cnt 
    from PRESENT_PERIF.ORDER_ORDER_STATUS_DIM  DWH2_WCRM_CONST_STATUS_DIM
    where
        DWH2_WCRM_CONST_STATUS_DIM.STATUS_CUSTGROUP_DESCR  IN  ( '������������'  )  
),
q2 as(
    select count(*) cnt 
    from PRESENT_PERIF.ORDER_ORDER_STATUS_DIM  DWH2_WCRM_CONST_STATUS_DIM
)
select q1.cnt/q2.cnt from q1,q2
-- 0,07


with q1
as(
    select count(*) cnt 
    from PRESENT_PERIF.CONSTR_ORDER_TYPE_DIM  DWH2_WCRM_ORDER_TYPE_DIM
    where
        DWH2_WCRM_ORDER_TYPE_DIM.CONSTR_ORDER_CODE in ('NP_EXTLLU')
),
q2 as(
    select count(*) cnt 
    from PRESENT_PERIF.CONSTR_ORDER_TYPE_DIM  DWH2_WCRM_ORDER_TYPE_DIM
)
select q1.cnt/q2.cnt from q1,q2
-- 0,003

select count(*)
from 

select *
from PRESENT_PERIF.CONSTR_ORDER_TYPE_DIM DWH2_WCRM_ORDER_TYPE_DIM


--- join filters: check order LEADING(DWH2_WCRM_ORDER_TYPE_DIM, CONSTR_WCRM_FCT
with q1
as(
    select count(*) cnt 
    from PRESENT_PERIF.CONSTR_ORDER_TYPE_DIM  DWH2_WCRM_ORDER_TYPE_DIM, PRESENT_PERIF.CONSTR_WCRM_FCT
    where
        -- single table filters
        DWH2_WCRM_ORDER_TYPE_DIM.CONSTR_ORDER_CODE in ('NP_EXTLLU')
        AND
           case 
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'P%' then 'Portability'
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'D%' then 'Disconnection'
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'U%' then 'Update'
            else 'Undefined'
        end  IN  ( 'Portability'  )
           AND
           PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_DATE_TRUNC  >=  date'2015-01-01'
        -- join conditions
        AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_ORDER_SK=DWH2_WCRM_ORDER_TYPE_DIM.CONSTR_ORDER_SK  )   
    --174,075                          
),
q2 as(
select count(*) cnt 
    from PRESENT_PERIF.CONSTR_WCRM_FCT
    where
          case 
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'P%' then 'Portability'
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'D%' then 'Disconnection'
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'U%' then 'Update'
            else 'Undefined'
        end  IN  ( 'Portability'  )
           AND
           PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_DATE_TRUNC  >=  date'2015-01-01' 
           --824,776
)
select q1.cnt/q2.cnt from q1,q2
-- 0,2


--- join filters: check order LEADING(DWH2_WCRM_ORDER_TYPE_DIM, CONSTR_WCRM_FCT
with q1
as(
    select count(*) cnt 
    from PRESENT_PERIF.ORDER_ORDER_STATUS_DIM  DWH2_WCRM_CONST_STATUS_DIM, PRESENT_PERIF.CONSTR_WCRM_FCT
    where
        -- single table filters
        DWH2_WCRM_CONST_STATUS_DIM.STATUS_CUSTGROUP_DESCR  IN  ( '������������'  )  
        AND
           case 
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'P%' then 'Portability'
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'D%' then 'Disconnection'
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'U%' then 'Update'
            else 'Undefined'
        end  IN  ( 'Portability'  )
           AND
           PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_DATE_TRUNC  >=  date'2015-01-01'
        -- join conditions
        AND  ( PRESENT_PERIF.CONSTR_WCRM_FCT.ORDER_STATUS_SK=DWH2_WCRM_CONST_STATUS_DIM.STATUS_SK  )   
    --696,547                       
),
q2 as(
select count(*) cnt 
    from PRESENT_PERIF.CONSTR_WCRM_FCT
    where
          case 
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'P%' then 'Portability'
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'D%' then 'Disconnection'
            when ( PRESENT_PERIF.CONSTR_WCRM_FCT.NP_ID_NUMBER ) like 'U%' then 'Update'
            else 'Undefined'
        end  IN  ( 'Portability'  )
           AND
           PRESENT_PERIF.CONSTR_WCRM_FCT.CONSTR_DATE_TRUNC  >=  date'2015-01-01' 
           --824,776
)
select q1.cnt/q2.cnt from q1,q2
-- 0,8