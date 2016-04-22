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
   
   l_retval.javascript_function := 'function(){ apex.custom.plugin.irQuickFilter(this.affectedElements,"'||apex_plugin.get_ajax_identifier||'");}';
   
   RETURN l_retval;
END;
FUNCTION apex_ir_get_columns (
   p_dynamic_action IN apex_plugin.t_dynamic_action,
   p_plugin         IN apex_plugin.t_plugin
)
   RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT
IS
  c sys_refcursor;
  l_ir_base_id NUMBER(20) := apex_application.g_x01;
BEGIN
  open c for 
   select 'All columns' D, '0' R, '0' C
     from dual
    union all
   select sys.htf.escape_sc(report_label) D, column_alias R, '1' C
     from apex_application_page_ir_col 
    where application_id = :APP_ID
      and page_id = :APP_PAGE_ID
      and display_text_as != 'HIDDEN'
      and interactive_report_id = l_ir_base_id;

  apex_json.open_object;
  apex_json. write('row', c);
  apex_json.close_object;
  
   RETURN NULL;
END;