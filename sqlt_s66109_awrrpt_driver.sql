REM $Header: 215187.1 sqlt_s66109_awrrpt_driver.sql 11.4.5.9 2013/07/15 carlos.sierra $
VAR dbid NUMBER;
VAR inst_num NUMBER;
VAR bid NUMBER;
VAR eid NUMBER;
VAR rpt_options NUMBER;
EXEC :rpt_options := 0;
SET ECHO OFF FEED OFF VER OFF SHOW OFF HEA OFF LIN 2000 NEWP NONE PAGES 0 LONG 2000000 LONGC 2000 SQLC MIX TAB ON TRIMS ON TI OFF TIMI OFF ARRAY 100 NUMF "" SQLP SQL> SUF sql BLO . RECSEP OFF APPI OFF AUTOT OFF;
--
HOS zip -m sqlt_s66109_driver sqlt_s66109_awrrpt_driver.sql
