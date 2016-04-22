FUNCTION apex_ir_get_qf_columns(
    p_dynamic_action IN apex_plugin.t_dynamic_action,
    p_plugin         IN apex_plugin.t_plugin )
RETURN apex_plugin.t_dynamic_action_render_result
IS
   l_retval APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;
   l_dateformat  VARCHAR2(20);
BEGIN
   IF apex_application.g_debug
   THEN
      apex_plugin_util.debug_dynamic_action(
         p_plugin         => p_plugin,
         p_dynamic_action => p_dynamic_action 
      );
   END IF;
   
   l_retval.javascript_function := 
      'function(){
         $("#apexir_WORKSHEET_REGION").bind("apexafterrefresh",
            function(){
            $("#apexir_SEARCHDROPROOT").removeAttr("onclick").click(
                                  function(){
                                     $.post("wwv_flow.show", 
                                            {"p_request"           : "PLUGIN='||apex_plugin.get_ajax_identifier||'",
                                             "p_flow_id"           : $v("pFlowId"),
                                             "p_flow_step_id"      : $v("pFlowStepId"),
                                             "p_instance"          : $v("pInstance"),
                                             "x01"                 : $v("apexir_WORKSHEET_ID")
                                             }, 
                                             function(data, status, obj){
                                                p = obj;
                                                if(gReport){
                                                   gReport.l_Action = "CONTROL";
                                                   gReport.current_control = "SEARCH_COLUMN";
                                                   gReport._Return(obj);
                                                };
                                             }
                                           );
                                
                                  return false;
                               });}
                 );
                 $("#apexir_WORKSHEET_REGION").trigger("apexafterrefresh");}';

   RETURN l_retval;
END;
FUNCTION apex_ir_get_columns (
   p_dynamic_action IN apex_plugin.t_dynamic_action,
   p_plugin         IN apex_plugin.t_plugin
)
   RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT
IS
   lv_json CLOB;
   l_ir_base_id NUMBER(20) := apex_application.g_x01;
BEGIN

apex_util.json_from_sql(q'!
   select 'All columns' D, '0' R, '0' C
     from dual
    union all
   select sys.htf.escape_sc(report_label) D, column_alias R, '1' C
     from apex_application_page_ir_col 
    where application_id = :APP_ID
      and page_id = :APP_PAGE_ID
      and interactive_report_id = !' ||l_ir_base_id
);

   RETURN NULL;
END;