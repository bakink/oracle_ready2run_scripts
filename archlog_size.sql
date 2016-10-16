set colsep "|"

SELECT * FROM (
SELECT A.*, B.SIZE_GB, DECODE(C.SIZE_GB, NULL, 0, C.SIZE_GB) DELETED_GB, B.SIZE_GB - DECODE(C.SIZE_GB, NULL, 0, C.SIZE_GB) REMAIN_GB 
FROM (SELECT * FROM (SELECT TO_DATE(b.date_time, 'DD/MM/YYYY') dt, TO_CHAR(TO_DATE(b.date_time, 'DD/MM/YYYY'), 'DAY') DAY, 
"00", "01",  "02", "03", "04", "05", "06", "07", "08", "09", 
"10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", TOTAL 
FROM (SELECT  date_time, 
SUM(DECODE(HOUR,'00',1,NULL)) "00", SUM(DECODE(HOUR,'01',1,NULL)) "01", SUM(DECODE(HOUR,'02',1,NULL)) "02", 
SUM(DECODE(HOUR,'03',1,NULL)) "03", SUM(DECODE(HOUR,'04',1,NULL)) "04", SUM(DECODE(HOUR,'05',1,NULL)) "05", 
SUM(DECODE(HOUR,'06',1,NULL)) "06", SUM(DECODE(HOUR,'07',1,NULL)) "07", SUM(DECODE(HOUR,'08',1,NULL)) "08", 
SUM(DECODE(HOUR,'09',1,NULL)) "09", SUM(DECODE(HOUR,'10',1,NULL)) "10", SUM(DECODE(HOUR,'11',1,NULL)) "11",
SUM(DECODE(HOUR,'12',1,NULL)) "12", SUM(DECODE(HOUR,'13',1,NULL)) "13", SUM(DECODE(HOUR,'14',1,NULL)) "14",
SUM(DECODE(HOUR,'15',1,NULL)) "15", SUM(DECODE(HOUR,'16',1,NULL)) "16", SUM(DECODE(HOUR,'17',1,NULL)) "17",
SUM(DECODE(HOUR,'18',1,NULL)) "18", SUM(DECODE(HOUR,'19',1,NULL)) "19", SUM(DECODE(HOUR,'20',1,NULL)) "20",
SUM(DECODE(HOUR,'21',1,NULL)) "21", SUM(DECODE(HOUR,'22',1,NULL)) "22", SUM(DECODE(HOUR,'23',1,NULL)) "23", COUNT(*) TOTAL  
FROM (SELECT TO_CHAR(first_time, 'DD/MM/YYYY') DATE_TIME,  
SUBSTR(TO_CHAR(first_time, 'DD/MM/YYYY HH24:MI:SS'),12,2) HOUR FROM V$LOG_HISTORY)
--where date_time = '06/12/2004' 
GROUP BY date_time) b)) A, 
(SELECT TO_CHAR(FIRST_TIME, 'DD/MM/YYYY') DATE_TIME, 
SUM(ROUND((blocks*block_size)/(1024*1024*1024),3)) SIZE_GB 
FROM v$archived_log GROUP BY TO_CHAR(FIRST_TIME, 'DD/MM/YYYY')) B, 
(SELECT TO_CHAR(FIRST_TIME, 'DD/MM/YYYY') DATE_TIME, 
SUM(ROUND((blocks*block_size)/(1024*1024*1024),3)) SIZE_GB 
FROM v$archived_log WHERE DELETED = 'YES' GROUP BY TO_CHAR(FIRST_TIME, 'DD/MM/YYYY')) C 
WHERE TO_CHAR(A.DT, 'DD/MM/YYYY') = B.DATE_TIME 
AND TO_CHAR(A.DT, 'DD/MM/YYYY') = c.DATE_TIME(+)
) ORDER BY dt DESC
/

set colsep " "