create or replace package PKG_3_ETL_TOOLS is

  -- Author  : xuclc
  -- Created : 2016/5/11 10:12:22
  -- Purpose : �ռ�ʧЧͳ����Ϣ������ͳ����Ϣ

  -- ���ݷ������ӷ�����ͳ����ϢʧЧ��������ֶԴ����ռ�ͳ����Ϣ
  procedure p_gather_table_stats(avc_schema in varchar2 --������Ҫ�ռ�ͳ����Ϣ���û�
                        );
 --�����嵥���������ͳ����Ϣstatistics      
  procedure p_lock_table_statistics(avc_schema in varchar2,--�����û���
                                    avc_list_tab in varchar2 --�������嵥
     ); 
  
  --����sip����ִ��sql
  procedure p_execute_sql(avc_sql in varchar2);                          
      
end PKG_3_ETL_TOOLS;
/
create or replace package body PKG_3_ETL_TOOLS is

  -------------------------------------------------------------
  -- ��������p_gather_table_stats
  -- ���ܣ����ݷ������ӷ�����ͳ����ϢʧЧ��������ֶԴ����ռ�ͳ����Ϣ 
  -- ���������
  --     avc_schema in varchar2 --������Ҫ�ռ�ͳ����Ϣ���û�
  -- ���������
  -- �������ڣ� 2016/5/11 
  -- �����ˣ�   xuclc
  -- �������鿴ͳ�ƽ���ʧЧ�ı�
  /* select \*+ unnest *\
  distinct owner, table_name, stale_stats
    from dba_tab_statistics
   where (last_analyzed is null or stale_stats = 'YES')
     and owner = 'J1_LDM' */
  ------------------------------------------------------------- 
  procedure p_gather_table_stats(avc_schema in varchar2 --������Ҫ�ռ�ͳ����Ϣ���û�
                                 ) is
    --01. stale_table_global�����Ƿ������ͳ����ϢʧЧ
    cursor stale_table_global is
      select /*+ unnest */
      distinct owner, table_name
        from dba_tab_statistics
       where (last_analyzed is null or stale_stats = 'YES')
         and owner = upper(avc_schema)
            --�ų�partition_name,subpartition_name
         and partition_name is null
         and subpartition_name is null;
  
    --02. stale_table_part����һά�������ͳ����ϢʧЧ
    cursor stale_table_part is
      select /*+ unnest */
      distinct owner, table_name, partition_name
        from dba_tab_statistics
       where (last_analyzed is null or stale_stats = 'YES')
         and owner = upper(avc_schema)
            --ȷ��partition_name���ų�subpartition_name
         and partition_name is not null
         and subpartition_name is null;
  
    --03.stale_table_subpart�����ά�������ͳ����ϢʧЧ
    cursor stale_table_subpart is
      select distinct owner, table_name, partition_name
        from dba_tab_statistics
       where (last_analyzed is null or stale_stats = 'YES')
         and owner = upper(avc_schema)
         and partition_name is not null
         and subpartition_name is not null;
  
  begin
    --01.�����Ƿ������ͳ����ϢʧЧ
    --SELECT * FROM USER_TAB_MODIFICATIONS��չʾͳ�ƽ������Ϊ��Ϣ����ʵʱˢ�µ������ֵ䣬����
    dbms_stats.flush_database_monitoring_info;
    for stale in stale_table_global loop
      begin
        dbms_stats.gather_table_stats(ownname          => stale.owner,
                                      tabname          => stale.table_name,
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      --for all columns size repeat�滻for all indexed columns
                                      method_opt  => 'for all indexed columns',
                                      degree      => 8,
                                      granularity => 'GLOBAL',
                                      cascade     => true,
                                      --force - gather statistics of table even if it is locked.
                                      force => true);
      exception
        when others then
          --raise_application_error(-20001, to_char(sqlcode) || sqlerrm);
          print_proc(to_char(sqlcode) || sqlerrm);
      end;
    end loop;
  
    --02.����һά�������ͳ����ϢʧЧ
    dbms_stats.flush_database_monitoring_info;
    for stale_part in stale_table_part loop
      begin
        dbms_stats.gather_table_stats(ownname          => stale_part.owner,
                                      tabname          => stale_part.table_name,
                                      partname         => stale_part.partition_name,
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      --for all columns size repeat�滻for all indexed columns
                                      method_opt  => 'for all indexed columns',
                                      degree      => 8,
                                      granularity => 'PARTITION',
                                      cascade     => true,
                                      --force - gather statistics of table even if it is locked.
                                      force => true);
      exception
        when others then
          --raise_application_error(-20001, to_char(sqlcode) || sqlerrm);
          print_proc(to_char(sqlcode) || sqlerrm);
      end;
    end loop;
  
    --03.�����ά�������ͳ����ϢʧЧ
    dbms_stats.flush_database_monitoring_info;
    for stale_subpart in stale_table_subpart loop
      begin
        dbms_stats.gather_table_stats(ownname          => stale_subpart.owner,
                                      tabname          => stale_subpart.table_name,
                                      partname         => stale_subpart.partition_name,
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      --for all columns size repeat�滻for all indexed columns
                                      method_opt  => 'for all indexed columns',
                                      degree      => 8,
                                      granularity => 'SUBPARTITION',
                                      cascade     => true,
                                      --force - gather statistics of table even if it is locked.
                                      force => true);
      exception
        when others then
          --raise_application_error(-20001, to_char(sqlcode) || sqlerrm);
          print_proc(to_char(sqlcode) || sqlerrm);
      end;
    end loop;
  
  exception
    when others THEN
      print_proc(to_char(sqlcode) || sqlerrm);
  end;
  -------------------------------------------------------------
  -- ��������p_lock_table_statistics
  -- ���ܣ����ݷ������ӷ�����ͳ����ϢʧЧ��������ֶԴ����ռ�ͳ����Ϣ 
  -- ���������
  --  avc_schema in varchar2    --�����û���
  --  avc_list_tab in varchar2  --�������嵥
  -- ���������
  -- �������ڣ� 2016/5/11 
  -- �����ˣ�   xuclc
  -- ��־��ETL_TAB_STATISTICS_LOG
  --��֤���鿴ͳ����Ϣ�����ı�
  /*select distinct owner,
                  table_name,
                  global_stats,
                  user_stats,
                  stattype_locked,
                  stale_stats
    from dba_tab_statistics
   where stattype_locked is not null
     AND owner = 'J1_LDM';
  --02 J1_DW   
   select distinct owner,
                  table_name,
                  stattype_locked
    from dba_tab_statistics
   where stattype_locked is not null
     AND owner = 'J1_DW';  
  --03 J1_LDCX
  select distinct owner,
                  table_name,
                  global_stats,
                  user_stats,
                  stattype_locked,
                  stale_stats
    from dba_tab_statistics
   where stattype_locked is not null
     AND owner = 'J1_LDCX';*/
  ------------------------------------------------------------- 
  procedure p_lock_table_statistics(avc_schema   in varchar2, --�����û���
                                    avc_list_tab in varchar2 --�������嵥
                                    ) is
    lvc_tabname  varchar2(50 char);
    lvc_schema   varchar2(50 char);
    lvc_list_tab varchar2(50 char);
    lvc_msg      varchar2(4000 char);
    type type_lock_list is table of varchar2(50 char) index by binary_integer;
    lock_list type_lock_list;
    i         number;
  begin
    --�����������
    if avc_schema is null then
      return;
    else
      lvc_schema := upper(trim(avc_schema));
    end if;
  
    if avc_list_tab is null then
      return;
    else
      lvc_list_tab := upper(trim(avc_list_tab));
    end if;
  
    execute immediate 'select lock_tab from ' || lvc_schema || '.' ||
                      lvc_list_tab bulk collect
      into lock_list;
    --print_proc(lock_list(1));
    for i in 1 .. lock_list.count loop
      begin
        lvc_tabname := lock_list(i);
        dbms_stats.lock_table_stats(ownname  => lvc_schema,
                                    tabname  => lvc_tabname,
                                    stattype => 'ALL');
        --print_proc(lvc_tabname);
        insert into J1_DW.ETL_TAB_STATISTICS_LOG
          (owner,table_name, exe_time, opt_type, out_msg)
        values
          (lvc_schema,lvc_tabname, sysdate, 'LOCK STATISTICS', '�ɹ�');
        commit;
      exception
        when others then
          lvc_msg := to_char(sqlcode) || sqlerrm;
          --dbms_output.put_line(to_char(sqlcode) || sqlerrm);
          insert into J1_DW.ETL_TAB_STATISTICS_LOG
            (owner,table_name, exe_time, opt_type, out_msg)
          values
            (lvc_schema,lvc_tabname, sysdate, 'LOCK STATISTICS', lvc_msg);
          commit;
      end;
    end loop;
  end;

  -------------------------------------------------------------
  -- ��������p_execute_sql
  -- ���ܣ�����sip���е��ȹ�������Ĳ��е���
  -- ���������
  --     avc_sql in varchar2  ����sql
  -- ���������
  -- �������ڣ� 2016/5/11 
  -- �����ˣ�   xuclc
  ------------------------------------------------------------- 
  procedure p_execute_sql(avc_sql in varchar2) is
    lvc_sql varchar2(4000 char);
  begin
    if lvc_sql is null then
      return;
    else
      lvc_sql := trim(avc_sql);
    end if;
    execute immediate lvc_sql;
  end;

end PKG_3_ETL_TOOLS;
/
