menu_series<- tabItem(tabName = "series",
                      fluidRow(
                        column(width = 12,
                               tabBox(title ="series工作台",width = 12,
                                      id='tabSet_series',height = '300px',
                                      tabPanel('主数据分析-品牌渠道',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          dataTableOutput("mrpt_analysis_md_division_summary")
                                          
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          
                                          dataTableOutput("mrpt_analysis_md_division_drilldown")
                                        )
                                        ))
                                        
                                      )),
                                      tabPanel('主数据分析-成本中心',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          mdl_text('mrpt_audit_md_costCenter_Year',label = '年份',value =tsdo::left(as.character(Sys.Date()),4)),
                                          mdl_integer(id = 'mrpt_audit_md_costCenter_Period',label = '月份',min = 1,max = 12,
                                                      value = as.integer(strsplit(as.character(Sys.Date()),'-')[[1]][2]),step = 1),
                                          actionButton(inputId = 'mrpt_audit_md_costCenter_btn',label = '成本中心分析'),
                                          
                                          dataTableOutput("mrpt_audit_md_costCenter_summary")
                                          
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          
                                          dataTableOutput("mrpt_audit_md_costCenter_detail")
                                        )
                                        )),
                                        fluidRow(column(6,box(title = "成本中心-独立", width = NULL, solidHeader = TRUE, status = "primary",
                                                              dataTableOutput("mrpt_audit_md_costCenter_detail_owned"))),
                                                 column(6,box(title = "成本中心-共享", width = NULL, solidHeader = TRUE, status = "primary",
                                                              dataTableOutput("mrpt_audit_md_costCenter_detail_shared")))),
                                        fluidRow(column(12,box(title = "成本中心-明细", width = NULL, solidHeader = TRUE, status = "primary",
                                                               dataTableOutput("mrpt_audit_md_costCenter_detail_list")))
                                                 
                                                 
                                        
                                      ))),
                                      
                                      tabPanel('主数据分析-成本要素',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          mdl_text('mrpt_audit_md_costItem_Year',label = '年份',value =tsdo::left(as.character(Sys.Date()),4)),
                                          mdl_integer(id = 'mrpt_audit_md_costItem_Period',label = '月份',min = 1,max = 12,
                                                      value = as.integer(strsplit(as.character(Sys.Date()),'-')[[1]][2]),step = 1),
                                          actionButton(inputId = 'mrpt_audit_md_costItem_btn',label = '成本要素分析'),
                                          
                                          dataTableOutput("mrpt_audit_md_costItem_summary")
                                          
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          
                                          dataTableOutput("mrpt_audit_md_costItem_detail")
                                        )
                                        ))
                                        
                                      )),
                                      tabPanel('凭证分析-重分类前',tagList(
                                        fluidRow(column(5,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                         
                                          mdl_text('voucher_audit_beforeReclass_Year',label = '年份',value =tsdo::left(as.character(Sys.Date()),4)),
                                          mdl_integer(id = 'voucher_audit_beforeReclass_Period',label = '月份',min = 1,max = 12,
                                                      value = as.integer(strsplit(as.character(Sys.Date()),'-')[[1]][2]),step = 1),
                                          actionButton(inputId = 'voucher_audit_beforeReclass_btn',label = '凭证分析'),
                                          tags$h4('成本要素汇总分析:'),
                                          div(style = 'overflow-x: scroll',dataTableOutput("voucher_beforeReClass_summary_dt"))
                                          
                                        )),
                                        column(7, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tags$h4('成本要素+成本中心代码汇总分析:'),
                                          div(style = 'overflow-x: scroll',dataTableOutput("voucher_beforeReClass_detail_dt1"))
                                        )
                                        )),
                                        fluidRow(column(12,box(
                                          title = "明细信息", width = NULL, solidHeader = TRUE, status = "primary",
                                          div(style = 'overflow-x: scroll',dataTableOutput("voucher_beforeReClass_detail_dt2"))
                                          ))
                                        
                                      ))),
                                      tabPanel('凭证分析-重分类后',tagList(
                                        fluidRow(column(5,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          
                                          mdl_text('voucher_audit_afterReclass_Year',label = '年份',value =tsdo::left(as.character(Sys.Date()),4)),
                                          mdl_integer(id = 'voucher_audit_afterReclass_Period',label = '月份',min = 1,max = 12,
                                                      value = as.integer(strsplit(as.character(Sys.Date()),'-')[[1]][2]),step = 1),
                                          actionButton(inputId = 'voucher_audit_afterReclass_btn',label = '凭证分析'),
                                          tags$h4('成本要素汇总分析:'),
                                          div(style = 'overflow-x: scroll',dataTableOutput("voucher_afterReClass_summary_dt"))
                                          
                                        )),
                                        column(7, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tags$h4('成本要素+成本中心代码汇总分析:'),
                                          div(style = 'overflow-x: scroll',dataTableOutput("voucher_afterReClass_detail_dt1"))
                                        )
                                        )),
                                        fluidRow(column(12,box(
                                          title = "明细信息", width = NULL, solidHeader = TRUE, status = "primary",
                                          div(style = 'overflow-x: scroll',dataTableOutput("voucher_afterReClass_detail_dt2"))
                                        ))
                                        
                                        ))),
                                      tabPanel('凭证分析-仅重分类凭证',tagList(
                                        fluidRow(column(5,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          
                                          mdl_text('voucher_audit_onlyReclass_Year',label = '年份',value =tsdo::left(as.character(Sys.Date()),4)),
                                          mdl_integer(id = 'voucher_audit_onlyReclass_Period',label = '月份',min = 1,max = 12,
                                                      value = as.integer(strsplit(as.character(Sys.Date()),'-')[[1]][2]),step = 1),
                                          actionButton(inputId = 'voucher_audit_onlyReclass_btn',label = '凭证分析'),
                                          tags$h4('成本要素汇总分析:'),
                                          div(style = 'overflow-x: scroll',dataTableOutput("voucher_onlyReClass_summary_dt"))
                                          
                                        )),
                                        column(7, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tags$h4('成本要素+成本中心代码汇总分析:'),
                                          div(style = 'overflow-x: scroll',dataTableOutput("voucher_onlyReClass_detail_dt1"))
                                        )
                                        )),
                                        fluidRow(column(12,box(
                                          title = "明细信息", width = NULL, solidHeader = TRUE, status = "primary",
                                          div(style = 'overflow-x: scroll',dataTableOutput("voucher_onlyReClass_detail_dt2"))
                                        ))
                                        
                                        ))),
                                      
                                      tabPanel('sheet3',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'sheet3'
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'rpt3'
                                        )
                                        ))
                                        
                                      )),
                                      tabPanel('sheet4',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'sheet4'
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'rpt4'
                                        )
                                        ))
                                        
                                      ))
                                      
                                      
                                      
                               )
                        )
                      )
)