set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040100 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,1377027056414870));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2011.02.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,130);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/dynamic_action/plugins_dynamicactions_irqfcolumns
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 436165710917776375 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'DYNAMIC ACTION'
 ,p_name => 'PLUGINS.DYNAMICACTIONS.IRQFCOLUMNS'
 ,p_display_name => 'IR Quick Filter All Columns'
 ,p_category => 'INIT'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'FUNCTION apex_ir_get_qf_columns('||unistr('\000a')||
'    p_dynamic_action IN apex_plugin.t_dynamic_action,'||unistr('\000a')||
'    p_plugin         IN apex_plugin.t_plugin )'||unistr('\000a')||
'RETURN apex_plugin.t_dynamic_action_render_result'||unistr('\000a')||
'IS'||unistr('\000a')||
'   l_retval APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;'||unistr('\000a')||
'   l_dateformat  VARCHAR2(20);'||unistr('\000a')||
'BEGIN'||unistr('\000a')||
'   IF apex_application.g_debug'||unistr('\000a')||
'   THEN'||unistr('\000a')||
'      apex_plugin_util.debug_dynamic_action('||unistr('\000a')||
'         p_plugin         => p_plugi'||
'n,'||unistr('\000a')||
'         p_dynamic_action => p_dynamic_action '||unistr('\000a')||
'      );'||unistr('\000a')||
'   END IF;'||unistr('\000a')||
'   '||unistr('\000a')||
'   l_retval.javascript_function := '||unistr('\000a')||
'      ''function(){'||unistr('\000a')||
'         $("#apexir_WORKSHEET_REGION").bind("apexafterrefresh",'||unistr('\000a')||
'            function(){'||unistr('\000a')||
'            $("#apexir_SEARCHDROPROOT").removeAttr("onclick").click('||unistr('\000a')||
'                                  function(){'||unistr('\000a')||
'                                     $.post("wwv_flow.show", '||unistr('\000a')||
'      '||
'                                      {"p_request"           : "PLUGIN=''||apex_plugin.get_ajax_identifier||''",'||unistr('\000a')||
'                                             "p_flow_id"           : $v("pFlowId"),'||unistr('\000a')||
'                                             "p_flow_step_id"      : $v("pFlowStepId"),'||unistr('\000a')||
'                                             "p_instance"          : $v("pInstance"),'||unistr('\000a')||
'                               '||
'              "x01"                 : $v("apexir_WORKSHEET_ID")'||unistr('\000a')||
'                                             }, '||unistr('\000a')||
'                                             function(data, status, obj){'||unistr('\000a')||
'                                                p = obj;'||unistr('\000a')||
'                                                if(gReport){'||unistr('\000a')||
'                                                   gReport.l_Action = "CONTROL";'||unistr('\000a')||
'              '||
'                                     gReport.current_control = "SEARCH_COLUMN";'||unistr('\000a')||
'                                                   gReport._Return(obj);'||unistr('\000a')||
'                                                };'||unistr('\000a')||
'                                             }'||unistr('\000a')||
'                                           );'||unistr('\000a')||
'                                '||unistr('\000a')||
'                                  return false;'||unistr('\000a')||
'                      '||
'         });}'||unistr('\000a')||
'                 );'||unistr('\000a')||
'                 $("#apexir_WORKSHEET_REGION").trigger("apexafterrefresh");}'';'||unistr('\000a')||
''||unistr('\000a')||
'   RETURN l_retval;'||unistr('\000a')||
'END;'||unistr('\000a')||
'FUNCTION apex_ir_get_columns ('||unistr('\000a')||
'   p_dynamic_action IN apex_plugin.t_dynamic_action,'||unistr('\000a')||
'   p_plugin         IN apex_plugin.t_plugin'||unistr('\000a')||
')'||unistr('\000a')||
'   RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT'||unistr('\000a')||
'IS'||unistr('\000a')||
'   lv_json CLOB;'||unistr('\000a')||
'   l_ir_base_id NUMBER(20) := apex_application.g_x01;'||unistr('\000a')||
'BEGIN'||unistr('\000a')||
''||
''||unistr('\000a')||
'apex_util.json_from_sql(q''!'||unistr('\000a')||
'   select ''All columns'' D, ''0'' R, ''0'' C'||unistr('\000a')||
'     from dual'||unistr('\000a')||
'    union all'||unistr('\000a')||
'   select sys.htf.escape_sc(report_label) D, column_alias R, ''1'' C'||unistr('\000a')||
'     from apex_application_page_ir_col '||unistr('\000a')||
'    where application_id = :APP_ID'||unistr('\000a')||
'      and page_id = :APP_PAGE_ID'||unistr('\000a')||
'      and interactive_report_id = !'' ||l_ir_base_id'||unistr('\000a')||
');'||unistr('\000a')||
''||unistr('\000a')||
'   RETURN NULL;'||unistr('\000a')||
'END;'
 ,p_render_function => 'apex_ir_get_qf_columns'
 ,p_ajax_function => 'apex_ir_get_columns'
 ,p_standard_attributes => 'ONLOAD'
 ,p_substitute_attributes => true
 ,p_version_identifier => '1.0'
 ,p_about_url=>'https://github.com/tompetrus/oracle-apex-ir-quickfilter'
 ,p_plugin_comment=>'Author: Tom Petrus, 2014'
  );
null;
 
end;
/

commit;
begin 
execute immediate 'begin dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
prompt  ...done
