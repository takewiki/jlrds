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
                                      
                                      tabPanel('报表分析-管报反查表',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          mdl_text('audit_FI_RPA_Year',label = '年份',value =tsdo::left(as.character(Sys.Date()),4)),
                                          mdl_integer(id = 'audit_FI_RPA_Period',label = '月份',min = 1,max = 12,
                                                      value = as.integer(strsplit(as.character(Sys.Date()),'-')[[1]][2]),step = 1),
                                          checkboxInput(inputId = 'audit_onlyError_btn',label = '仅显示差异项',value = FALSE,width = '100%'),
                                          mdl_numeric(id = 'audit_onlyError_value',label = '差异值设置',value = 0.1,min = 0.1,max = 1.0,step = 0.1,width = '100%'),
                                          
                                          
                                          
                                          actionButton(inputId = 'audit_FI_RPA_btn',label = '报表反查'),
                                          mdl_download_button(id = 'audit_FI_RPA_dl',label = '下载反查表'),
                                          hr(),
                                          dataTableOutput("audit_FI_RPA_summary"),
                                    
                                       
                                          
                                          
                                      
                                          
                                
                                          
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          
                                          dataTableOutput("audit_FI_RPA_detail"),
                                          uiOutput('audit_FI_RPA_detail_action')
                                        )
                                        )),
                                        fluidRow(column(12,box(title = "过程表-SAP凭证", width = NULL, solidHeader = TRUE, status = "primary",
                                                              div(style = 'overflow-x: scroll',dataTableOutput("audit_FI_RPA_detail_SAP")),
                                                              mdl_download_button(id = 'audit_FI_RPA_detail_SAP_dl',label = '下载SAP凭证数据源')))
                                                 ),
                                        fluidRow(column(12,box(title = "过程表-手调凭证", width = NULL, solidHeader = TRUE, status = "primary",
                                                               div(style = 'overflow-x: scroll',dataTableOutput("audit_FI_RPA_detail_ADJ")),
                                                               mdl_download_button(id = 'audit_FI_RPA_detail_ADJ_dl',label = '下载手调凭证数据源')
                                                               ))),
                                        
                                        fluidRow(column(12,box(title = "过程表-BW报表", width = NULL, solidHeader = TRUE, status = "primary",
                                                               div(style = 'overflow-x: scroll',dataTableOutput("audit_FI_RPA_detail_BW")),
                                                               mdl_download_button(id = 'audit_FI_RPA_detail_BW_dl',label = '下载BW报表数据源')
                                                               ))
                                                 
                                                 
                                                 
                                        ))),
                                      tabPanel('报表分析-品牌费用明细查询',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          mdl_text('audit_FI_RPA_Year3',label = '年份',value =tsdo::left(as.character(Sys.Date()),4)),
                                          mdl_integer(id = 'audit_FI_RPA_Period3',label = '月份',min = 1,max = 12,
                                                      value = as.integer(strsplit(as.character(Sys.Date()),'-')[[1]][2]),step = 1),
                                          actionButton(inputId = 'audit_FI_RPA_btn3',label = '过程表查询'),
                                          dataTableOutput("audit_FI_RPA_summary3")
                                          
                                        ))),
                                        fluidRow(column(12,box(title = "过程表-品牌渠道所有明细", width = NULL, solidHeader = TRUE, status = "primary",
                                                               div(style = 'overflow-x: scroll',dataTableOutput("audit_FI_RPA_detail3")),
                                                               mdl_download_button(id = 'audit_FI_RPA_detail_dl3',label = '下载管理过程表')))
                                        )
                                        )),
                                      tabPanel('报表分析-SAP凭证号查询',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          mdl_text('voucher_audit_afterReclass_Year2',label = '年份',value =tsdo::left(as.character(Sys.Date()),4)),
                                          mdl_integer(id = 'voucher_audit_afterReclass_Period2',label = '月份',min = 1,max = 12,
                                                      value = as.integer(strsplit(as.character(Sys.Date()),'-')[[1]][2]),step = 1),
                                          mdl_text('voucher_audit_afterReclass_vchNo2',label = '参考凭证号',value = '4901907219'),
                                          actionButton(inputId = 'voucher_audit_afterReclass_btn2',label = '凭证分析'),
                                          mdl_download_button(id = 'voucher_audit_afterReclass_dl2',label = '下载凭证')
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          div(style = 'overflow-x: scroll',mdl_dataTable("voucher_audit_afterReclass_dataView2"))
                                        )
                                        ))
                                        
                                      ))
                                      
                                      
                                      
                               )
                        )
                      )
)
