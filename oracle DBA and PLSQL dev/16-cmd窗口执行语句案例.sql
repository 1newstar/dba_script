set col 40;
prompt 1.©��
prompt  
prompt (1)Դ��INF������������
select distinct t.table_name
  from j1_g3_zbq.etl_trans_log t, j1_ldm.etl_loadldm_log t1
 where 
 --�������������
   t.table_name = t1.table_name
   and trunc(t.start_time) = trunc((t1.start_time - 3 / 24))
   and t.start_time < t1.start_time
 --���ˣ�����
   and t.start_time > trunc(sysdate - 1,'mm')
   and t1.start_time > trunc(sysdate - 1,'mm')
 --���ˣ�����
   and t.table_name like 'INF%'
 --ȡ���ݣ�Դ��INF����INF��LDM�Ŀ�ʼ
   and t.end_time > t1.start_time
   order by t.table_name desc;
prompt   
prompt (2)©���������
set col 100;
select distinct table_name,
                e_count as ��ȡ�ɹ�����,
                sjlyxt,
                sum(trans_count) as Դ��INF��ȡ_����,
                sum(inf_to_ldm_count) as INF��LDM��ȡ_����
  from (select COUNT(t.V_QSRQ) OVER(partition by t.table_name, trunc(t.start_time, 'mm') order by t.start_time desc range between unbounded preceding and unbounded following) as e_count,
                t.table_name,
                t.trans_count,
                t.sjlyxt,
                substr(t.v_qsrq, 1, 8) as v_qsrq,
                t1.trans_count as inf_to_ldm_count
           from j1_g3_zbq.etl_trans_log t, j1_ldm.etl_loadldm_log t1
          where
         --�������������
          t.table_name = t1.table_name
       and trunc(t.start_time) = trunc((t1.start_time - 3 / 24))
       and t.start_time < t1.start_time
         --���ˣ�����
       and t.start_time > trunc(sysdate - 1, 'mm')
       and t1.start_time > trunc(sysdate - 1, 'mm')
         --���ˣ�����
       and t.table_name like 'INF%'
         --�ɹ���Դ��INF����INF��LDM�Ŀ�ʼ
       and t.end_time < t1.start_time
       and t.trans_count <> '-1')
--�޸ĳɹ���ȡ����  e_count
 where e_count < 24
 group by table_name, e_count, sjlyxt;

prompt   
prompt 2.����
prompt declare
prompt     an_rownum NUMBER;;
prompt begin
select distinct 
  'j1_g3_zbq.cp_trans_g3sjzg(avc_schema =>''HX_ZGXT'',
      avc_table_name => ''' ||table_name || ''',
      an_rownum => an_rownum,
      avc_sswjg => ''00000000000'',
      avc_qsrq => '' 20160801 000000 '',
      avc_zzrq => '' 20160830 235959 '',
      avc_sjlyxt => ''' || sjlyxt || ''');' as "----------"
  from (select COUNT(t.V_QSRQ) OVER(partition by t.table_name, trunc(t.start_time, 'mm') order by t.start_time desc range between unbounded preceding and unbounded following) as e_count,
                t.table_name,
                t.trans_count,
                t.sjlyxt,
                substr(t.v_qsrq, 1, 8) as v_qsrq,
                t1.trans_count as inf_to_ldm_count
           from j1_g3_zbq.etl_trans_log t, j1_ldm.etl_loadldm_log t1
          where
         --�������������
          t.table_name = t1.table_name
       and trunc(t.start_time) = trunc((t1.start_time - 3 / 24))
       and t.start_time < t1.start_time
         --���ˣ�����
       and t.start_time > trunc(sysdate - 1, 'mm')
       and t1.start_time > trunc(sysdate - 1, 'mm')
         --���ˣ�����
       and t.table_name like 'INF%'
         --�ɹ���Դ��INF����INF��LDM�Ŀ�ʼ
       and t.end_time < t1.start_time
       and t.trans_count <> '-1')
--�޸ĳɹ���ȡ����  e_count
 where e_count < 24
 group by table_name,sjlyxt;
 set col 40;
prompt end;;