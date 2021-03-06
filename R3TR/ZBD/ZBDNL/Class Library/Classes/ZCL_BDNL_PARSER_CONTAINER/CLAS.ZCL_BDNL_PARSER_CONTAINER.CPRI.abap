*"* private components of class ZCL_BDNL_PARSER_CONTAINER
*"* do not include other source files here!!!
private section.

  class-data CD_V__CNT_CLEAR type I .
  type-pools ZBNLT .
  data GD_T__RANGE type ZBNLT_T__STACK_RANGE .
  data GD_T__STACK type ZBNLT_T__CONTAINER .
  data GR_O__CURSOR type ref to ZCL_BDNL_CURSOR .

  methods FILTER_STATEMENTS
    exporting
      !E_S__STACK type ZBNLT_S__STACK_RANGE
    raising
      ZCX_BDNL_EXCEPTION
      CX_STATIC_CHECK .
  methods FILTER_PRIM
    raising
      ZCX_BDNL_EXCEPTION
      CX_STATIC_CHECK .
  methods PROCESS_FUNCTION
    returning
      value(E_T__PARAM) type ZBNLT_T__PARAM
    raising
      ZCX_BDNL_EXCEPTION
      CX_STATIC_CHECK .
  type-pools ZBD0T .
  methods SELECT_PARAM_FIELDS
    importing
      !I_V__TYPE_TABLE type STRING
      !I_APPSET_ID type UJ_APPSET_ID
      !I_APPL_ID type UJ_APPL_ID
      !I_APPL_OBJ type ref to ZCL_BD00_APPLICATION
    exporting
      !E_T__ALIAS type ZBD00_T_ALIAS
      !E_T__DIMLIST type ZBD00_T_CH_KEY
      !E_V__TECH_TYPE_TABLE type ZBD00_TYPE_APPL_TABLE
      !E_T__DIMENSION type ZBD0T_TY_T_DIM
      !E_T__KEY_LIST type ZBD0T_TY_T_KF
      !E_F__WRITE type RS_BOOL
    raising
      ZCX_BDNL_EXCEPTION .
  methods CMD_FROM
    exporting
      !E_APPSET_ID type UJ_APPSET_ID
      !E_APPL_ID type UJ_APPL_ID
      !E_DIM_NAME type UJ_DIM_NAME
      !E_APPL_OBJ type ref to ZCL_BD00_APPLICATION
      !E_DIST type STRING
    raising
      ZCX_BDNL_EXCEPTION
      ZCX_BD00_CREATE_OBJ .
  methods SELECT_PARAM_INTO
    exporting
      !E_V__TYPE_TABLE type STRING
      !E_V__TABLENAME type ZBNLT_V__TABLENAME
    raising
      ZCX_BDNL_EXCEPTION .
  methods TABLE_PARAM_CONST
    importing
      !I_APPSET_ID type UJ_APPSET_ID
      !I_APPL_ID type UJ_APPL_ID
    exporting
      !E_T__CONST type ZBD0T_TY_T_CONSTANT
    raising
      ZCX_BDNL_EXCEPTION
      CX_STATIC_CHECK .
  methods SELECT_PARAM_WHERE
    importing
      !I_APPSET_ID type UJ_APPSET_ID
      !I_APPL_ID type UJ_APPL_ID optional
      !I_APPL_OBJ type ref to ZCL_BD00_APPLICATION optional
    exporting
      !E_T__RANGE type UJ0_T_SEL
    raising
      ZCX_BDNL_EXCEPTION
      CX_STATIC_CHECK .
  methods SELECT_WHERE_OPT
    importing
      !TOKEN type STRING
    exporting
      !OPTION type DDOPTION
    raising
      ZCX_BDNL_EXCEPTION .
  methods PRIM
    raising
      ZCX_BDNL_EXCEPTION
      CX_STATIC_CHECK .
  methods SELECT_STATEMENTS
    exporting
      !E_O__CONTAINER type ref to ZCL_BDNL_CONTAINER
      !E_V__TABLENAME type ZBNLT_V__TABLENAME
    raising
      ZCX_BDNL_EXCEPTION
      CX_STATIC_CHECK .
  methods CLEAR_STATEMENTS
    exporting
      !E_O__CONTAINER type ref to ZCL_BDNL_CONTAINER
      !E_V__TABLENAME type ZBNLT_V__TABLENAME
    raising
      ZCX_BDNL_EXCEPTION
      CX_STATIC_CHECK .
  methods TABLE_STATEMENTS
    exporting
      !E_O__CONTAINER type ref to ZCL_BDNL_CONTAINER
      !E_V__TABLENAME type ZBNLT_V__TABLENAME
    raising
      ZCX_BDNL_EXCEPTION
      CX_STATIC_CHECK .
