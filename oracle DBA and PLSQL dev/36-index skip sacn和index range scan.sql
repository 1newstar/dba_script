select sql_fulltext from gv$sqlarea where sql_id='5vuxd3x96n08t'

--ִ�мƻ���
--------------------------------------------------------------------------------------------------------------
| Id  | Operation                         | Name                     | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------------------
|   0 | INSERT STATEMENT                  |                          |     2 |   212 | 15792   (1)| 00:04:45 |
|   1 |  LOAD TABLE CONVENTIONAL          | TMP_DM2_LDCX_DJ_SWDJQKTJ |       |       |            |          |
|*  2 |   FILTER                          |                          |       |       |            |          |
|   3 |    SORT GROUP BY                  |                          |     2 |   212 | 15792   (1)| 00:04:45 |
|   4 |     NESTED LOOPS                  |                          |   567 | 60102 | 15792   (1)| 00:04:45 |
|   5 |      NESTED LOOPS                 |                          |  2538 | 60102 | 15792   (1)| 00:04:45 |
|   6 |       SORT UNIQUE                 |                          |   564 | 29892 | 13246   (1)| 00:03:59 |
|*  7 |        TABLE ACCESS BY INDEX ROWID| LDMT02_JCXY_SZDJXXB      |   564 | 29892 | 13246   (1)| 00:03:59 |
|*  8 |         INDEX SKIP SCAN           | IDX$$_024A0001           |  1128 |       | 12350   (1)| 00:03:43 |
|*  9 |       INDEX RANGE SCAN            | IDX$$_024A0001           |     9 |       |     2   (0)| 00:00:01 |
|* 10 |      TABLE ACCESS BY INDEX ROWID  | LDMT02_JCXY_SZDJXXB      |     1 |    53 |    10   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------------------------
   2 - filter(COUNT(DISTINCT NLSSORT("T"."ZSXM_DM",'nls_sort=''BINARY'''))<:SYS_B_06)
   7 - filter("N"."ZSDLFS_DM"=:SYS_B_10 AND "N"."YXQQ"<=:SYS_B_07 AND "N"."XYBZ"=:SYS_B_09 AND 
              "N"."YXQZ">=:SYS_B_08 AND "N"."SJBGBZ"<>:SYS_B_12 AND "N"."YXQQ"<"N"."YXQZ")
   8 - access("N"."ZSXM_DM"=:SYS_B_11)
       filter("N"."ZSXM_DM"=:SYS_B_11)
   9 - access("T"."NSRZHDAH"="N"."NSRZHDAH")
  10 - filter("T"."ZSDLFS_DM"=:SYS_B_04 AND "T"."YXQQ"<=:SYS_B_01 AND "T"."XYBZ"=:SYS_B_03 AND 
              "T"."YXQZ">=:SYS_B_02 AND "T"."SJBGBZ"<>:SYS_B_05 AND "T"."YXQQ"<"T"."YXQZ")
  
������
[1]INDEX SKIP SCAN           | IDX$$_024A0001           |  1128
  ----J1_LDM.IDX$$_024A0001 on J1_LDM.LDMT02_JCXY_SZDJXXB (NSRZHDAH, ZSXM_DM)
  --������Ծ ����ǰ����Ψһֵ�ĸ�����ÿ��Ψһֵ��Ϊɨ��ĳ������,�ڴ˻����Ͻ���һ�β���,���ϲ����ҽ����
  --ǰ��ֵ���٣���sckip scan
  select count(*) from (select distinct  NSRZHDAH  from  J1_LDM.LDMT02_JCXY_SZDJXXB) --1169033�����  
  select count(*) from (select distinct  ZSXM_DM  from  J1_LDM.LDMT02_JCXY_SZDJXXB)  --27�����
  --ZSXM_DM��������Ϊǰ��

  ------------------------------------------
    create index J1_LDM.IDX$$_02B50001 on
    J1_LDM.LDMT02_JCXY_SZDJXXB("ZSXM_DM","ZSDLFS_DM","XYBZ","YXQQ");
    create index J1_LDM.IDX$$_02B50002 on
    J1_LDM.LDMT02_JCXY_SZDJXXB("NSRZHDAH");
 
--ִ�мƻ���
--------------------------------------------------------------------------------------------------------------
| Id  | Operation                         | Name                     | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------------------
|   0 | INSERT STATEMENT                  |                          |     2 |   212 |  6337   (1)| 00:01:55 |
|   1 |  LOAD TABLE CONVENTIONAL          | TMP_DM2_LDCX_DJ_SWDJQKTJ |       |       |            |          |
|*  2 |   FILTER                          |                          |       |       |            |          |
|   3 |    SORT GROUP BY                  |                          |     2 |   212 |  6337   (1)| 00:01:55 |
|   4 |     NESTED LOOPS                  |                          |   567 | 60102 |  6336   (1)| 00:01:55 |
|   5 |      NESTED LOOPS                 |                          |  2538 | 60102 |  6336   (1)| 00:01:55 |
|   6 |       SORT UNIQUE                 |                          |   564 | 29892 |  4076   (1)| 00:01:14 |
|*  7 |        TABLE ACCESS BY INDEX ROWID| LDMT02_JCXY_SZDJXXB      |   564 | 29892 |  4076   (1)| 00:01:14 |
|*  8 |         INDEX RANGE SCAN          | IDX$$_02B50001           |  7559 |       |    12   (0)| 00:00:01 |
|*  9 |       INDEX RANGE SCAN            | IDX$$_02B50002           |     9 |       |     2   (0)| 00:00:01 |
|* 10 |      TABLE ACCESS BY INDEX ROWID  | LDMT02_JCXY_SZDJXXB      |     1 |    53 |     8   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------------------------
   2 - filter(COUNT(DISTINCT NLSSORT("T"."ZSXM_DM",'nls_sort=''BINARY'''))<:SYS_B_06)
   7 - filter("N"."YXQZ">=:SYS_B_08 AND "N"."SJBGBZ"<>:SYS_B_12 AND "N"."YXQQ"<"N"."YXQZ")
   8 - access("N"."ZSXM_DM"=:SYS_B_11 AND "N"."ZSDLFS_DM"=:SYS_B_10 AND "N"."XYBZ"=:SYS_B_09 AND 
              "N"."YXQQ"<=:SYS_B_07)
   9 - access("T"."NSRZHDAH"="N"."NSRZHDAH")
  10 - filter("T"."ZSDLFS_DM"=:SYS_B_04 AND "T"."YXQQ"<=:SYS_B_01 AND "T"."XYBZ"=:SYS_B_03 AND 
              "T"."YXQZ">=:SYS_B_02 AND "T"."SJBGBZ"<>:SYS_B_05 AND "T"."YXQQ"<"T"."YXQZ")
