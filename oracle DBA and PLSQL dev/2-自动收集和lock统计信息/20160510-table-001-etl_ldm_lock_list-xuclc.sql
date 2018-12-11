prompt Created on 2016��5��10�� by xuclc
set feedback off

--define TABLESPACE_NAME=&1;
--define INDEX_TABLESPACE_NAME=&2;

-- ============================================================
--   Table: J1_LDM.ETL_LDM_LOCK_LIST
--   ��������: J1_LDM�û�����ldm��ͳ����Ϣ���嵥
--   ����ʱ��: 2016��5��10��
--   �����ˣ� xuclc
-- ============================================================
prompt '��J1_LDM.ETL_LDM_LOCK_LIST��������'
prompt '����ǰ,J1_LDM.ETL_LDM_LOCK_LIST�Ƿ��Ѵ������紴��������ɾ��'

DECLARE
  LI_COUNT NUMBER(10); --���Ƿ���ڱ�־
  LVC_SQL  VARCHAR2(2000 CHAR);
BEGIN
    SELECT COUNT(*)
      INTO LI_COUNT
      FROM USER_TABLES
     WHERE TABLE_NAME = 'ETL_LDM_LOCK_LIST';
    IF LI_COUNT = 1 THEN
      LVC_SQL := 'TRUNCATE TABLE ETL_LDM_LOCK_LIST';
      EXECUTE IMMEDIATE LVC_SQL;
      LVC_SQL := 'DROP TABLE ETL_LDM_LOCK_LIST';
      EXECUTE IMMEDIATE LVC_SQL;
    END IF;
    lvc_sql:='create table etl_ldm_lock_list
    as
    select replace(table_name, ''INF'', ''LDM'') as lock_tab,
       trans_count,
       ceil((end_time-start_time)*24*60) as consume_minus
    from j1_ldm.etl_loadldm_log
    where start_time > trunc(sysdate)
    and trans_count > 1000
    order by trans_count desc';
    
    EXECUTE IMMEDIATE lvc_sql;

END;
/

    comment on table ETL_LDM_LOCK_LIST is 'J1_LDM�û�����ldm��ͳ����Ϣ���嵥';
    comment on column ETL_LDM_LOCK_LIST.lock_tab
    is 'ldm����';
    comment on column etl_ldm_lock_list.trans_count
    is '��ȡ��������';
    comment on column etl_ldm_lock_list.consume_minus
    is '��ȡ���ĵ�ʱ��';
    

set feedback on
prompt Done.

