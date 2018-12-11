-- һϵ��oracle����(regular expresstion)
/******************************************************
regexp_like
--(1)����like������,����where���;
--(2)��������select�־�
--�﷨
--regexp_like(srcstr,pattern,[,match_option])
--match_option:
--'c',���ִ�Сд(Ĭ��)
--'i',�����ִ�Сд��
--'n',����ƥ�������ַ�ƥ�任�з�
--'m',����Ԫ�ַ����������

regexp_instr
--(1)Ѱ��һ��������ʽƥ�䣬�����ҵ�ƥ�䷵��һ�������ַ�����λ�ã�
--(2)����instr����������λ��
--�﷨��
--regexp_inst(srcstr,partern[, posttion,occurrence,return_option,match_option])
--position: ������ʼ��λ��
--occurrence�������ַ����ĳ���
--return_option:��ʾ�����Ŀ�ʼ���߽���λ��


regexp_replace
 --(1)����һ��������ʽ�����滻�ַ��滻��;
 --(2)����replace���� 
 --�﷨
 --regexp_substr(srcstr,partern[, replacestr,position,occurrence,match_option])

regexp_substr
 --����һ��ƥ����ִ�
 --����substr
 --�﷨
  regexp_substr(srcstr,partern[, posttion,occurrence,match_option])


*******************************************************/

/*=====================================================
POSIX Ԫ�ַ�(POSIX��׼�ַ���)
--Ԫ�ַ��Ǿ������⺬��������ַ�
=======================================================*/

--(1)
--* ƥ��0,���߸���

select * from j1_dw.etl_meta_unit where regexp_like(unit_name,'(*)');
---------------------------------------------
--(2)
--| ����ƥ��
--(0|2)����ƥ��0��2
select * from j1_dw.etl_meta_unit where regexp_like(unit_name,'P_DM(0|2)_(YH|ZM)');
--result:
   P_DM0_YH_SSJMSPXXQC
   P_DM2_YH_SSJMSPHSTJB
--------------------------------------------
--(3)
--^ ƥ���п�ʼ
--(^5) 5��ͷ
select * from j1_dw.etl_meta_unit where regexp_like(unit_id,'(^5)');

--reult:
   548.02
--------------------------------------------
--(4)
--$ ƥ���н���
--(5$) 5����
select * from j1_dw.etl_meta_unit where regexp_like(unit_id,'(5$)');
--result:
       5029.05
--------------------------------------------
--(5)
--[] ƥ���б����κ�һ����ʾ�ı��ʽ�����ű��ʽ
--[(5$),(^5)] 5��ͷ����5��β

select * from j1_dw.etl_meta_unit where regexp_like(unit_id,'[(5$),(^5)]');
       --result:
       548.02
       934.05
--[((5|2)$)(^(1|5))] 5����2��ͷ��1����5��β
--����[((5|2)$),(^(1|5))]
select * from j1_dw.etl_meta_unit where regexp_like(unit_id,'[((5|2)$)(^(1|5))]');

---------------------------------------------
--(6)
--[^exp] ������������ʽ�ķ񶨱��

----------------------------------------------
--(7)
--{m}��ȷƥ��m��
--(X){2} ��ȷƥ��2��X
select * from j1_ldcx.etl_meta_unit where regexp_like(unit_code,'(X){2}');
  --result:
  P_DM0_YHS_DJHZXX
---------------------------------------------
--(8)
--[::] ָ��һ���ַ��࣬ƥ������������ַ�

---------------------------------------------
--(9)
--\
--���ֺ��壺1����������2��������һ���ַ���3������һ����������4��do nothing
---------------------------------------------
--(10)
--+
--ƥ��һ�����߶���¼�
---------------------------------------------
--(11)
--?
--ƥ��0������һ���¼�
--****oracle 11g������ʹ��
----------------------------------------------
--(12)
--. ƥ������֧�ֵ��ַ���NULL����
--(X){2}.(Z){2}(Q){2}��ȷƥ��X���Σ�Z���Σ�Q����
select * from j1_ldcx.etl_meta_unit where regexp_like(unit_code,'(X){2}.(Z){2}(Q){2}');
--result:
       P_DM0_ZK_SWDJXXWZZQQKQC
       P_DM2_ZK_SWDJXXWZZQQKTJ
--=============================================
--(13)
--()
--������ʽ������һ���������ӱ��ʽ
---------------------------------------------
--(14)
--\n
--�������ñ��ʽ
---------------------------------------------
--(15)
--[==]
--ָ���ȼ���
---------------------------------------------
--(16)
--[..]
--ָ��һ������Ԫ�أ�

/*=====================================================
Perl������ʽ��չ
--����POSXI��׼��oracle֧��Perl_influencedԪ�ַ�
=======================================================*/
--\d  һ�������ַ�
--\D  һ���������ַ�
--\w  һ����ĸ�ַ�
--\W  һ������ĸ�ַ�
--\s  һ���հ��ַ�
--\S  һ���ǿհ��ַ�
--\A  ƥ�俪ͷ���ַ�
--\Z  ƥ������ַ������߻��з�
--\z  ƥ��������ַ�
--*?  ƥ��0���߸����
--+?  ƥ��1���߸����
--??  ƥ��0����1��
--{n}? ƥ��n��
--{n��m}? ƥ�����n�Σ�С��M��

/*=====================================================
oracle ������ʽʹ�ü���

--(1)ʹ��������ʽ���Լ������
--��������Լ��֮�󣬿������������ʽ��������������Ƿ����Լ��
=======================================================*/

--(1)���unit_codeԼ����PKG��ͷ
alter table etl_meta_unit_bak add constraint etl_meta_unit_unit_code
check(regexp_like(unit_code,'(^PKG)')) enable novalidate;

--test
insert into etl_meta_unit_bak(unit_id,unit_code) values('5500.02','p_test')
 --ORA-02290: check constraint (J1_LDM.ETL_META_UNIT_UNIT_CODE) violated

--(2)���unit_idԼ�����е�
alter table etl_meta_unit_bak add constraint etl_meta_unit_unit_id
check(regexp_like(unit_id,'\.')) enable novalidate;

--test
insert into etl_meta_unit_bak(unit_id,unit_code) values('5500','PKG')
--ORA-02290: check constraint (J1_LDM.ETL_META_UNIT_UNIT_ID) violated




