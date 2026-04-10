prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- NOTE: Template IDs (p_plug_template, p_button_template_id, p_item_template)
-- are workspace-specific. After import, verify region/item templates match your
-- Universal Theme installation.  All component IDs use wwv_flow_imp.id() and
-- will be remapped by the import offset.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.15'
,p_default_workspace_id=>8157687763422631
,p_default_application_id=>125
,p_default_id_offset=>0
,p_default_owner=>'WKSP_LEPPARD'
);
end;
/

prompt APPLICATION 125 - DART Demo
--
-- Application Export:
--   Application:     125
--   Name:            DART Demo
--   Exported By:     JOHN.A.KOLDEN@GMAIL.COM
--   Flashback:       0
--   Export Type:     Page Export
--   Manifest
--     PAGE: 100
--   Manifest End
--   Version:         24.2.15
--

begin
null;
end;
/
prompt --application/pages/delete_00100
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>100);
end;
/
prompt --application/pages/page_00100
begin
wwv_flow_imp_page.create_page(
 p_id=>100
,p_name=>'DART Deposit Batch'
,p_alias=>'DART-DEPOSIT-BATCH'
,p_step_title=>'DART Deposit Batch #000001'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* ── DART page-level overrides ── */',
'.dart-hofi .apex-item-text { font-weight:700; text-transform:uppercase; letter-spacing:.1em; color:#c74634; }',
'.dart-amount .apex-item-text { font-variant-numeric:tabular-nums; font-weight:600; }',
'.dart-badge { display:inline-block; padding:2px 10px; border-radius:12px; font-size:11px; font-weight:600; }',
'.dart-badge-incomplete { background:#eef3fb; color:#005baa; }',
'.dart-badge-complete { background:#edf7ed; color:#1a7c37; }',
'.dart-status-tag { display:inline-block; padding:3px 10px; border-radius:4px; font-size:11px; font-weight:700; color:#fff; }',
'.dart-status-applied { background:#0d7c66; }',
'.dart-status-unapplied { background:#c47e10; }',
'.dart-num { text-align:right; font-variant-numeric:tabular-nums; }',
'.dart-foot-label { text-align:right; font-weight:700; }',
'.dart-chart-wrap { display:flex; align-items:center; gap:20px; }',
'.dart-donut { width:180px; height:180px; flex-shrink:0; }',
'.dart-donut-arc { transition:stroke-dasharray .4s ease, stroke-dashoffset .4s ease; }',
'.dart-legend { display:flex; flex-direction:column; gap:10px; }',
'.dart-legend-item { display:flex; gap:8px; align-items:flex-start; }',
'.dart-legend-swatch { width:10px; height:10px; border-radius:2px; margin-top:2px; flex-shrink:0; }',
'.dart-legend-label { font-size:11px; font-weight:600; }',
'.dart-legend-value { font-size:13px; font-weight:700; font-variant-numeric:tabular-nums; }',
'.dart-legend-pct { font-size:10px; color:#999; }',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
--------------------------------------------------------------------------------
-- REGION: Batch Information
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(90000001)
,p_plug_name=>'Batch Information'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
);
-- Page Items: Batch Category
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000101)
,p_name=>'P100_BATCH_CATEGORY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(90000001)
,p_prompt=>'Batch Category'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'STATIC:',
'Deposit;Deposit,',
'Transfer;Transfer,',
'Reallocation;Reallocation'))
,p_lov_display_null=>'NO'
,p_cHeight=>1
,p_begin_on_new_line=>'Y'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
-- Page Items: Batch Type (cascades from Category)
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000102)
,p_name=>'P100_BATCH_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(90000001)
,p_prompt=>'Batch Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT display_val d, return_val r',
'FROM (',
'  SELECT ''Swept Cash ZBA'' display_val, ''Swept Cash ZBA'' return_val, ''Deposit'' cat FROM DUAL UNION ALL',
'  SELECT ''Deposit Correction (Same-HOFI)'', ''Deposit Correction (Same-HOFI)'', ''Deposit'' FROM DUAL UNION ALL',
'  SELECT ''Deposit Correction (Cross-HOFI)'', ''Deposit Correction (Cross-HOFI)'', ''Deposit'' FROM DUAL UNION ALL',
'  SELECT ''Interfund Transfer'', ''Interfund Transfer'', ''Transfer'' FROM DUAL UNION ALL',
'  SELECT ''Intrafund Transfer'', ''Intrafund Transfer'', ''Transfer'' FROM DUAL UNION ALL',
'  SELECT ''Cash Transfer'', ''Cash Transfer'', ''Transfer'' FROM DUAL UNION ALL',
'  SELECT ''IA Reallocation'', ''IA Reallocation'', ''Reallocation'' FROM DUAL UNION ALL',
'  SELECT ''Project Reallocation'', ''Project Reallocation'', ''Reallocation'' FROM DUAL UNION ALL',
'  SELECT ''Fund Reallocation'', ''Fund Reallocation'', ''Reallocation'' FROM DUAL',
')',
'WHERE cat = :P100_BATCH_CATEGORY',
'ORDER BY 1'))
,p_lov_display_null=>'NO'
,p_lov_cascade_parent_items=>'P100_BATCH_CATEGORY'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
-- Page Items: Batch Status
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000103)
,p_name=>'P100_BATCH_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(90000001)
,p_prompt=>'Batch Status'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'STATIC:',
'Incomplete;Incomplete,',
'Pending Review;Pending Review,',
'Ready for Approval;Ready for Approval,',
'Complete;Complete'))
,p_lov_display_null=>'NO'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
-- Page Items: Batch Name
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000104)
,p_name=>'P100_BATCH_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(90000001)
,p_prompt=>'Batch Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>200
,p_begin_on_new_line=>'Y'
,p_colspan=>8
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
-- Page Items: Workflow Status
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000105)
,p_name=>'P100_WORKFLOW_STATUS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(90000001)
,p_prompt=>'Workflow Status'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'STATIC:',
'Not Submitted;Not Submitted,',
'Submitted;Submitted,',
'Awaiting HOFI Approval;Awaiting HOFI Approval,',
'Awaiting A&C Approval;Awaiting A&C Approval,',
'Approved;Approved,',
'Rejected;Rejected'))
,p_lov_display_null=>'NO'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
-- Page Items: Preparer Organization
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000106)
,p_name=>'P100_PREPARER_ORG'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(90000001)
,p_prompt=>'Preparer Organization'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'STATIC:',
'AUD ' || chr(8212) || ' Auditor & Controller;AUD,',
'TES ' || chr(8212) || ' Treasurer-Tax Collector;TES,',
'HHS ' || chr(8212) || ' Health & Human Services;HHS,',
'DPW ' || chr(8212) || ' Public Works;DPW,',
'SHR ' || chr(8212) || ' Sheriff;SHR,',
'LIB ' || chr(8212) || ' Library;LIB,',
'PLN ' || chr(8212) || ' Planning & Development;PLN'))
,p_lov_display_null=>'NO'
,p_cHeight=>1
,p_begin_on_new_line=>'Y'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
-- Page Items: Preparer Name (cascades from Organization)
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000107)
,p_name=>'P100_PREPARER_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(90000001)
,p_prompt=>'Preparer Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT display_val d, return_val r',
'FROM (',
'  SELECT ''Moana Wavecrest'' display_val, ''Moana Wavecrest'' return_val, ''AUD'' org FROM DUAL UNION ALL',
'  SELECT ''Kai Tidemark'', ''Kai Tidemark'', ''AUD'' FROM DUAL UNION ALL',
'  SELECT ''Leilani Shore'', ''Leilani Shore'', ''AUD'' FROM DUAL UNION ALL',
'  SELECT ''Levi Stream'', ''Levi Stream'', ''TES'' FROM DUAL UNION ALL',
'  SELECT ''Coral Banks'', ''Coral Banks'', ''TES'' FROM DUAL UNION ALL',
'  SELECT ''Marina Depth'', ''Marina Depth'', ''TES'' FROM DUAL UNION ALL',
'  SELECT ''Ava Harbor'', ''Ava Harbor'', ''HHS'' FROM DUAL UNION ALL',
'  SELECT ''Reef Castillo'', ''Reef Castillo'', ''HHS'' FROM DUAL UNION ALL',
'  SELECT ''Isla Sandoval'', ''Isla Sandoval'', ''HHS'' FROM DUAL UNION ALL',
'  SELECT ''Duncan Bridger'', ''Duncan Bridger'', ''DPW'' FROM DUAL UNION ALL',
'  SELECT ''Sierra Granite'', ''Sierra Granite'', ''DPW'' FROM DUAL UNION ALL',
'  SELECT ''Clay Asphalt'', ''Clay Asphalt'', ''DPW'' FROM DUAL UNION ALL',
'  SELECT ''Morgan Shield'', ''Morgan Shield'', ''SHR'' FROM DUAL UNION ALL',
'  SELECT ''Barrett Ironwood'', ''Barrett Ironwood'', ''SHR'' FROM DUAL UNION ALL',
'  SELECT ''Quinn Patrol'', ''Quinn Patrol'', ''SHR'' FROM DUAL UNION ALL',
'  SELECT ''Paige Turner'', ''Paige Turner'', ''LIB'' FROM DUAL UNION ALL',
'  SELECT ''Dewey Bookend'', ''Dewey Bookend'', ''LIB'' FROM DUAL UNION ALL',
'  SELECT ''Margot Shelf'', ''Margot Shelf'', ''LIB'' FROM DUAL UNION ALL',
'  SELECT ''Skyler Blueprint'', ''Skyler Blueprint'', ''PLN'' FROM DUAL UNION ALL',
'  SELECT ''Mason Parcel'', ''Mason Parcel'', ''PLN'' FROM DUAL UNION ALL',
'  SELECT ''Zara Overlay'', ''Zara Overlay'', ''PLN'' FROM DUAL',
')',
'WHERE org = :P100_PREPARER_ORG',
'ORDER BY 1'))
,p_lov_display_null=>'NO'
,p_lov_cascade_parent_items=>'P100_PREPARER_ORG'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
-- Page Items: Preparer HOFI
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000108)
,p_name=>'P100_PREPARER_HOFI'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(90000001)
,p_prompt=>'Preparer HOFI'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_cMaxlength=>10
,p_begin_on_new_line=>'N'
,p_colspan=>4,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
--------------------------------------------------------------------------------
-- REGION: Bank Deposit Context
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(90000002)
,p_plug_name=>'Bank Deposit Context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
);
-- Page Items: Bank Name (cascades from HOFI)
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000201)
,p_name=>'P100_BANK_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(90000002)
,p_prompt=>'Bank Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT name || '' ('' || hofi || '')'' d, name r',
'FROM (',
'  SELECT ''County of SD Pooled Cash ' || chr(8212) || ' Wells Fargo'' name, ''4021-7789-0001'' acct, ''AUD'' hofi FROM DUAL UNION ALL',
'  SELECT ''County of SD Pooled Cash ' || chr(8212) || ' Bank of America'', ''6833-4420-0055'', ''TES'' FROM DUAL UNION ALL',
'  SELECT ''County of SD Treasury ZBA ' || chr(8212) || ' Chase'', ''9102-5567-0032'', ''TES'' FROM DUAL UNION ALL',
'  SELECT ''HHS Grant Deposits ' || chr(8212) || ' US Bank'', ''7714-0098-2210'', ''HHS'' FROM DUAL UNION ALL',
'  SELECT ''Public Works Capital ' || chr(8212) || ' Citibank'', ''3308-6621-4477'', ''DPW'' FROM DUAL',
')',
'WHERE hofi = NVL(:P100_PREPARER_HOFI, hofi)',
'ORDER BY 1'))
,p_lov_display_null=>'NO'
,p_lov_cascade_parent_items=>'P100_PREPARER_HOFI'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'Y'
,p_colspan=>12
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
-- Page Items: Bank Account (read-only)
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000202)
,p_name=>'P100_BANK_ACCOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(90000002)
,p_prompt=>'Bank Account'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
-- Page Items: Bank Date
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000203)
,p_name=>'P100_BANK_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(90000002)
,p_prompt=>'Bank Date'
,p_format_mask=>'YYYY-MM-DD'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
);
-- Page Items: Bank Reference
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000204)
,p_name=>'P100_BANK_REFERENCE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(90000002)
,p_prompt=>'Bank Reference'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'Y'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
-- Page Items: Bank Amount (read-only, formatted)
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(90000205)
,p_name=>'P100_BANK_AMOUNT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(90000002)
,p_prompt=>'Bank Amount'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>6,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
--------------------------------------------------------------------------------
-- REGION: Deposit Distribution (static content — SVG donut chart)
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(90000003)
,p_plug_name=>'Deposit Distribution'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_plug_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="dart-chart-wrap">',
'  <svg viewBox="0 0 100 100" class="dart-donut">',
'    <circle cx="50" cy="50" r="40" fill="none" stroke="#e5e5e5" stroke-width="12"/>',
'    <!-- GL Lines: 62.5% -->',
'    <circle cx="50" cy="50" r="40" fill="none" stroke="#0572ce" stroke-width="12"',
'      stroke-dasharray="156.8 94.5" stroke-dashoffset="0" stroke-linecap="butt"',
'      transform="rotate(-90 50 50)" class="dart-donut-arc"/>',
'    <!-- PNG Lines: 9.5% -->',
'    <circle cx="50" cy="50" r="40" fill="none" stroke="#0d7c66" stroke-width="12"',
'      stroke-dasharray="23.9 227.4" stroke-dashoffset="-156.8" stroke-linecap="butt"',
'      transform="rotate(-90 50 50)" class="dart-donut-arc"/>',
'    <!-- AR Receipts: 48.0% -->',
'    <circle cx="50" cy="50" r="40" fill="none" stroke="#c74634" stroke-width="12"',
'      stroke-dasharray="120.6 130.7" stroke-dashoffset="-180.7" stroke-linecap="butt"',
'      transform="rotate(-90 50 50)" class="dart-donut-arc"/>',
'    <text x="50" y="47" text-anchor="middle" style="font-size:8px;fill:#999;font-weight:600;text-transform:uppercase;letter-spacing:.08em">Total</text>',
'    <text x="50" y="57" text-anchor="middle" style="font-size:8px;fill:#262626;font-weight:700;font-variant-numeric:tabular-nums">$211,800.70</text>',
'  </svg>',
'  <div class="dart-legend">',
'    <div class="dart-legend-item">',
'      <span class="dart-legend-swatch" style="background:#0572ce"></span>',
'      <div><span class="dart-legend-label">GL Lines</span><br/>',
'           <span class="dart-legend-value">$119,550.70</span><br/>',
'           <span class="dart-legend-pct">56.4%</span></div>',
'    </div>',
'    <div class="dart-legend-item">',
'      <span class="dart-legend-swatch" style="background:#0d7c66"></span>',
'      <div><span class="dart-legend-label">PNG Lines</span><br/>',
'           <span class="dart-legend-value">$18,200.00</span><br/>',
'           <span class="dart-legend-pct">8.6%</span></div>',
'    </div>',
'    <div class="dart-legend-item">',
'      <span class="dart-legend-swatch" style="background:#c74634"></span>',
'      <div><span class="dart-legend-label">AR Receipts</span><br/>',
'           <span class="dart-legend-value">$92,550.70</span><br/>',
'           <span class="dart-legend-pct">43.7%</span></div>',
'    </div>',
'  </div>',
'</div>'))
,p_plug_source_type=>'NATIVE_STATIC'
,p_attribute_01=>'HTML'
);
--------------------------------------------------------------------------------
-- REGION: GL Lines (Classic Report)
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(90000004)
,p_plug_name=>'GL Lines'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT id, fund, budget_ref, dept, account, program, funding_src, project,',
'       TO_CHAR(amount, ''FML999G999G999G990D00'') amount_fmt,',
'       description',
'FROM (',
'  SELECT 1 id, ''1010'' fund, ''0000'' budget_ref, ''15675'' dept, ''47535'' account, ''0000'' program, ''0000'' funding_src, ''00000000'' project, 45000.00 amount, ''State Public Health Reimbursement'' description FROM DUAL UNION ALL',
'  SELECT 2, ''1010'', ''0000'', ''14565'', ''47535'', ''1200'', ''3100'', ''00000000'', 25000.00, ''Federal Housing Authority Grant'' FROM DUAL UNION ALL',
'  SELECT 3, ''6114'', ''0000'', ''00000'', ''80100'', ''0000'', ''2001'', ''PRG10042'', 15000.00, ''Capital Improvement '' || chr(8212) || '' Road Resurfacing'' FROM DUAL UNION ALL',
'  SELECT 4, ''1010'', ''2026'', ''15675'', ''47200'', ''0000'', ''0000'', ''00000000'', 22550.70, ''Permit Fee Collections '' || chr(8212) || '' March'' FROM DUAL UNION ALL',
'  SELECT 5, ''2030'', ''2026'', ''16890'', ''48100'', ''2100'', ''3200'', ''PRG20014'', 12000.00, ''Behavioral Health Services Revenue'' FROM DUAL',
')',
'ORDER BY id'))
,p_plug_source_type=>'NATIVE_SQL_REPORT'
,p_plug_query_num_rows=>50
,p_plug_query_num_rows_type=>'SET'
,p_plug_query_show_nulls_as=>' '
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_header=>'<h4>GL Lines (5)</h4>'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000401)
,p_query_column_id=>1 ,p_column_alias=>'ID' ,p_column_display_sequence=>1
,p_column_heading=>'#' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000402)
,p_query_column_id=>2 ,p_column_alias=>'FUND' ,p_column_display_sequence=>2
,p_column_heading=>'Fund' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000403)
,p_query_column_id=>3 ,p_column_alias=>'BUDGET_REF' ,p_column_display_sequence=>3
,p_column_heading=>'Budget Ref' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000404)
,p_query_column_id=>4 ,p_column_alias=>'DEPT' ,p_column_display_sequence=>4
,p_column_heading=>'Dept' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000405)
,p_query_column_id=>5 ,p_column_alias=>'ACCOUNT' ,p_column_display_sequence=>5
,p_column_heading=>'Account' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000406)
,p_query_column_id=>6 ,p_column_alias=>'PROGRAM' ,p_column_display_sequence=>6
,p_column_heading=>'Program' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000407)
,p_query_column_id=>7 ,p_column_alias=>'FUNDING_SRC' ,p_column_display_sequence=>7
,p_column_heading=>'Funding Src' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000408)
,p_query_column_id=>8 ,p_column_alias=>'PROJECT' ,p_column_display_sequence=>8
,p_column_heading=>'Project' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000409)
,p_query_column_id=>9 ,p_column_alias=>'AMOUNT_FMT' ,p_column_display_sequence=>9
,p_column_heading=>'Amount' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000410)
,p_query_column_id=>10 ,p_column_alias=>'DESCRIPTION' ,p_column_display_sequence=>10
,p_column_heading=>'Description' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
--------------------------------------------------------------------------------
-- REGION: PNG Lines (Classic Report)
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(90000005)
,p_plug_name=>'PNG Lines'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>50
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT id, project, task, exp_type, exp_org, contract, funding_source,',
'       TO_CHAR(amount, ''FML999G999G999G990D00'') amount_fmt,',
'       description',
'FROM (',
'  SELECT 1 id, ''PRG10042'' project, ''1.0'' task, ''Contract Services'' exp_type, ''Public Works'' exp_org, ''DPW-24-301'' contract, ''Dept of Public Works'' funding_source, 8500.00 amount, ''Road Resurfacing '' || chr(8212) || '' Contract Labor Q4'' description FROM DUAL UNION ALL',
'  SELECT 2, ''PRG20014'', ''2.0'', ''Supplies'', ''Behavioral Health'', ''HHS-20-101'', ''Dept of Health & Human Services'', 3200.00, ''BHS Program Supplies'' FROM DUAL UNION ALL',
'  SELECT 3, ''PRG10042'', ''3.0'', ''Equipment Rental'', ''Public Works'', ''DPW-24-301'', ''Dept of Public Works'', 6500.00, ''Road Resurfacing '' || chr(8212) || '' Equipment Rental'' FROM DUAL',
')',
'ORDER BY id'))
,p_plug_source_type=>'NATIVE_SQL_REPORT'
,p_plug_query_num_rows=>50
,p_plug_query_num_rows_type=>'SET'
,p_plug_query_show_nulls_as=>' '
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_header=>'<h4>PNG Lines (3)</h4>'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000501)
,p_query_column_id=>1 ,p_column_alias=>'ID' ,p_column_display_sequence=>1
,p_column_heading=>'#' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000502)
,p_query_column_id=>2 ,p_column_alias=>'PROJECT' ,p_column_display_sequence=>2
,p_column_heading=>'Project' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000503)
,p_query_column_id=>3 ,p_column_alias=>'TASK' ,p_column_display_sequence=>3
,p_column_heading=>'Task' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000504)
,p_query_column_id=>4 ,p_column_alias=>'EXP_TYPE' ,p_column_display_sequence=>4
,p_column_heading=>'Exp Type' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000505)
,p_query_column_id=>5 ,p_column_alias=>'EXP_ORG' ,p_column_display_sequence=>5
,p_column_heading=>'Exp Org' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000506)
,p_query_column_id=>6 ,p_column_alias=>'CONTRACT' ,p_column_display_sequence=>6
,p_column_heading=>'Contract' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000507)
,p_query_column_id=>7 ,p_column_alias=>'FUNDING_SOURCE' ,p_column_display_sequence=>7
,p_column_heading=>'Funding Source' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000508)
,p_query_column_id=>8 ,p_column_alias=>'AMOUNT_FMT' ,p_column_display_sequence=>8
,p_column_heading=>'Amount' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000509)
,p_query_column_id=>9 ,p_column_alias=>'DESCRIPTION' ,p_column_display_sequence=>9
,p_column_heading=>'Description' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
--------------------------------------------------------------------------------
-- REGION: AR Receipt Lines (Classic Report)
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(90000006)
,p_plug_name=>'AR Receipt Lines'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>60
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT id, receipt_number, customer,',
'       TO_CHAR(amount, ''FML999G999G999G990D00'') amount_fmt,',
'       receipt_date,',
'       CASE WHEN status = ''Applied'' THEN ''<span class="dart-status-tag dart-status-applied">'' || status || ''</span>''',
'            ELSE ''<span class="dart-status-tag dart-status-unapplied">'' || status || ''</span>''',
'       END status_html,',
'       dart_batch',
'FROM (',
'  SELECT 1 id, ''AR-DART-000001-01'' receipt_number, ''State of California '' || chr(8212) || '' DHCS'' customer, 45000.00 amount, ''2026-03-27'' receipt_date, ''Applied'' status, ''DART-000001'' dart_batch FROM DUAL UNION ALL',
'  SELECT 2, ''AR-DART-000001-02'', ''US Dept of Housing & Urban Dev'', 25000.00, ''2026-03-27'', ''Applied'', ''DART-000001'' FROM DUAL UNION ALL',
'  SELECT 3, ''AR-DART-000001-03'', ''San Diego County Permits'', 22550.70, ''2026-03-27'', ''Unapplied'', ''DART-000001'' FROM DUAL',
')',
'ORDER BY id'))
,p_plug_source_type=>'NATIVE_SQL_REPORT'
,p_plug_query_num_rows=>50
,p_plug_query_num_rows_type=>'SET'
,p_plug_query_show_nulls_as=>' '
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_header=>'<h4>AR Receipt Lines (3)</h4>'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000601)
,p_query_column_id=>1 ,p_column_alias=>'ID' ,p_column_display_sequence=>1
,p_column_heading=>'#' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000602)
,p_query_column_id=>2 ,p_column_alias=>'RECEIPT_NUMBER' ,p_column_display_sequence=>2
,p_column_heading=>'Receipt Number' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000603)
,p_query_column_id=>3 ,p_column_alias=>'CUSTOMER' ,p_column_display_sequence=>3
,p_column_heading=>'Customer' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000604)
,p_query_column_id=>4 ,p_column_alias=>'AMOUNT_FMT' ,p_column_display_sequence=>4
,p_column_heading=>'Amount' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT' );
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000605)
,p_query_column_id=>5 ,p_column_alias=>'RECEIPT_DATE' ,p_column_display_sequence=>5
,p_column_heading=>'Receipt Date' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000606)
,p_query_column_id=>6 ,p_column_alias=>'STATUS_HTML' ,p_column_display_sequence=>6
,p_column_heading=>'Status' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(90000607)
,p_query_column_id=>7 ,p_column_alias=>'DART_BATCH' ,p_column_display_sequence=>7
,p_column_heading=>'DART Batch' ,p_use_as_row_header=>'N' ,p_heading_alignment=>'LEFT'
);
--------------------------------------------------------------------------------
-- BUTTONS
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(90000701)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(90000001)
,p_button_name=>'SAVE_LOCK'
,p_button_static_id=>'btnSaveLock'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save & Lock'
,p_button_position=>'CHANGE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-lock'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(90000702)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(90000001)
,p_button_name=>'CANCEL'
,p_button_static_id=>'btnCancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(90000703)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(90000001)
,p_button_name=>'UNLOCK'
,p_button_static_id=>'btnUnlock'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Unlock'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P100_BATCH_STATUS'
,p_button_condition2=>'Complete'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-unlock'
);
--------------------------------------------------------------------------------
-- DYNAMIC ACTION: Save & Lock
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(90000801)
,p_name=>'Save & Lock'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(90000701)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(90000811)
,p_event_id=>wwv_flow_imp.id(90000801)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Set status to Complete / Submitted',
'apex.item("P100_BATCH_STATUS").setValue("Complete");',
'apex.item("P100_WORKFLOW_STATUS").setValue("Submitted");',
'',
'// Disable all editable items',
'["P100_BATCH_CATEGORY","P100_BATCH_TYPE","P100_BATCH_NAME",',
' "P100_WORKFLOW_STATUS","P100_PREPARER_ORG","P100_PREPARER_NAME",',
' "P100_PREPARER_HOFI","P100_BANK_NAME","P100_BANK_DATE","P100_BANK_REFERENCE"]',
'  .forEach(function(id) { apex.item(id).disable(); });',
'',
'// Show success message',
'apex.message.showPageSuccess(',
'  "Batch saved and record locked. This bank deposit cannot be selected by another preparer."',
');',
'',
'// Toggle button visibility',
'$("#btnSaveLock").hide();',
'$("#btnUnlock").show();'))
);
--------------------------------------------------------------------------------
-- DYNAMIC ACTION: Unlock
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(90000802)
,p_name=>'Unlock'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(90000703)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(90000821)
,p_event_id=>wwv_flow_imp.id(90000802)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Reset status',
'apex.item("P100_BATCH_STATUS").setValue("Incomplete");',
'apex.item("P100_WORKFLOW_STATUS").setValue("Not Submitted");',
'',
'// Re-enable items',
'["P100_BATCH_CATEGORY","P100_BATCH_TYPE","P100_BATCH_NAME",',
' "P100_WORKFLOW_STATUS","P100_PREPARER_ORG","P100_PREPARER_NAME",',
' "P100_PREPARER_HOFI","P100_BANK_NAME","P100_BANK_DATE","P100_BANK_REFERENCE"]',
'  .forEach(function(id) { apex.item(id).enable(); });',
'',
'// Toggle buttons',
'$("#btnSaveLock").show();',
'$("#btnUnlock").hide();'))
);
--------------------------------------------------------------------------------
-- DYNAMIC ACTION: Cancel (reset form)
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(90000803)
,p_name=>'Cancel'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(90000702)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(90000831)
,p_event_id=>wwv_flow_imp.id(90000803)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Reset to initial values',
'apex.item("P100_BATCH_CATEGORY").setValue("Deposit");',
'apex.item("P100_BATCH_TYPE").setValue("Swept Cash ZBA");',
'apex.item("P100_BATCH_STATUS").setValue("Incomplete");',
'apex.item("P100_BATCH_NAME").setValue("AUDITMSCRT27MAR2026.DEMO");',
'apex.item("P100_WORKFLOW_STATUS").setValue("Not Submitted");',
'apex.item("P100_PREPARER_ORG").setValue("AUD");',
'apex.item("P100_PREPARER_NAME").setValue("Moana Wavecrest");',
'apex.item("P100_PREPARER_HOFI").setValue("AUD");',
'apex.item("P100_BANK_DATE").setValue("2026-03-27");',
'apex.item("P100_BANK_REFERENCE").setValue("0005794549XF");',
'',
'// Re-enable all items',
'["P100_BATCH_CATEGORY","P100_BATCH_TYPE","P100_BATCH_NAME",',
' "P100_WORKFLOW_STATUS","P100_PREPARER_ORG","P100_PREPARER_NAME",',
' "P100_PREPARER_HOFI","P100_BANK_NAME","P100_BANK_DATE","P100_BANK_REFERENCE"]',
'  .forEach(function(id) { apex.item(id).enable(); });',
'',
'$("#btnSaveLock").show();',
'$("#btnUnlock").hide();'))
);
--------------------------------------------------------------------------------
-- DYNAMIC ACTION: Org change sets HOFI
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(90000804)
,p_name=>'Org Change Sets HOFI'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P100_PREPARER_ORG'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(90000841)
,p_event_id=>wwv_flow_imp.id(90000804)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'apex.item("P100_PREPARER_ORG").getValue()'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P100_PREPARER_HOFI'
);
--------------------------------------------------------------------------------
-- DYNAMIC ACTION: Bank Name change fills Account
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(90000805)
,p_name=>'Bank Name Fills Account'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P100_BANK_NAME'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(90000851)
,p_event_id=>wwv_flow_imp.id(90000805)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var bankMap = {',
'  "County of SD Pooled Cash \u2014 Wells Fargo":     "4021-7789-0001",',
'  "County of SD Pooled Cash \u2014 Bank of America": "6833-4420-0055",',
'  "County of SD Treasury ZBA \u2014 Chase":          "9102-5567-0032",',
'  "HHS Grant Deposits \u2014 US Bank":               "7714-0098-2210",',
'  "Public Works Capital \u2014 Citibank":            "3308-6621-4477"',
'};',
'var sel = apex.item("P100_BANK_NAME").getValue();',
'apex.item("P100_BANK_ACCOUNT").setValue(bankMap[sel] || "");'))
);
--------------------------------------------------------------------------------
-- PAGE LOAD: Set default values
--------------------------------------------------------------------------------
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(90000806)
,p_name=>'Page Load Defaults'
,p_event_sequence=>60
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(90000861)
,p_event_id=>wwv_flow_imp.id(90000806)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Set initial values on page load',
'apex.item("P100_BATCH_CATEGORY").setValue("Deposit");',
'apex.item("P100_BATCH_TYPE").setValue("Swept Cash ZBA");',
'apex.item("P100_BATCH_STATUS").setValue("Incomplete");',
'apex.item("P100_BATCH_NAME").setValue("AUDITMSCRT27MAR2026.DEMO");',
'apex.item("P100_WORKFLOW_STATUS").setValue("Not Submitted");',
'apex.item("P100_PREPARER_ORG").setValue("AUD");',
'apex.item("P100_PREPARER_NAME").setValue("Moana Wavecrest");',
'apex.item("P100_PREPARER_HOFI").setValue("AUD");',
'apex.item("P100_BANK_ACCOUNT").setValue("4021-7789-0001");',
'$s("P100_BANK_DATE", "2026-03-27");',
'apex.item("P100_BANK_REFERENCE").setValue("0005794549XF");',
'apex.item("P100_BANK_AMOUNT").setValue("$119,550.70");',
'',
'// Hide Unlock button initially',
'$("#btnUnlock").hide();'))
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
