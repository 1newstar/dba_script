prompt Created on 2016��5��10�� by xuclc
set feedback off

--define TABLESPACE_NAME=&1;
--define INDEX_TABLESPACE_NAME=&2;

-- ============================================================
--   Table: etl_tab_statistics_log
--   ��������: ���ͳ����Ϣ��������־
--   ����ʱ��: 2016��5��11��
--   �����ˣ� xuclc
-- ============================================================
prompt '��etl_tab_statistics_log��������'
prompt '����ǰ,etl_tab_statistics_log�Ƿ��Ѵ������紴��������ɾ��'

DECLARE
  LI_COUNT NUMBER(10); --���Ƿ���ڱ�־
  LVC_SQL  VARCHAR2(2000 CHAR);
BEGIN
    SELECT COUNT(*)
      INTO LI_COUNT
      FROM USER_TABLES
     WHERE TABLE_NAME = 'ETL_TAB_STATISTICS_LOG';
    IF LI_COUNT = 1 THEN
      LVC_SQL := 'TRUNCATE TABLE ETL_TAB_STATISTICS_LOG';
      EXECUTE IMMEDIATE LVC_SQL;
      LVC_SQL := 'DROP TABLE ETL_TAB_STATISTICS_LOG';
      EXECUTE IMMEDIATE LVC_SQL;
    END IF;
END;
/

create table ETL_TAB_STATISTICS_LOG
(
       owner      varchar2(50 char),
       table_name varchar2(50 char),
       exe_time   date,
       opt_type   varchar2(500 char),
       out_msg    varchar2(4000 char)
);

comment on table ETL_TAB_STATISTICS_LOG is '���ͳ����Ϣ��������־';
comment on column ETL_TAB_STATISTICS_LOG.owner is '�û���';
comment on column ETL_TAB_STATISTICS_LOG.table_name is '����';
comment on column ETL_TAB_STATISTICS_LOG.exe_time is 'ִ��ʱ��';
comment on column ETL_TAB_STATISTICS_LOG.opt_type is '�������ͣ��ռ�ͳ����Ϣor����ͳ����Ϣ';
comment on column ETL_TAB_STATISTICS_LOG.out_msg is '�����־';

grant insert on ETL_TAB_STATISTICS_LOG to public;

set feedback on
prompt Done.

