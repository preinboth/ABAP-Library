*"* private components of class ZCL_BDNL_ASSIGN_FUNCTION
*"* do not include other source files here!!!
private section.

  class-methods __GET_TIME
    importing
      !TIME type STRING
    returning
      value(E) type I
    raising
      ZCX_BDNL_SKIP_ASSIGN .
