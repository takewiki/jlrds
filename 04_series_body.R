menu_series<- tabItem(tabName = "series",
                      fluidRow(
                        column(width = 12,
                               tabBox(title ="管报分析工作台",width = 12,
                                      id='tabSet_series',height = '300px',
                                      tabPanel('6.01主数据分析-品牌渠道',tagList(
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
                                      tabPanel('6.02主数据分析-成本中心',tagList(
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
                                      
                                      tabPanel('6.03主数据分析-成本要素',tagList(
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
                                      tabPanel('6.04凭证分析-重分类前',tagList(
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
                                      tabPanel('6.05凭证分析-重分类后',tagList(
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
                                      tabPanel('6.06凭证分析-仅重分类凭证',tagList(
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
                                      
                                      tabPanel('6.07报表分析-管报反查表',tagList(
                                        fluidRow(column(5,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          fluidRow(column(6,mdl_text('audit_FI_RPA_Year',label = '年份',value =tsdo::left(as.character(Sys.Date()),4))),
                                                   column(6,mdl_numeric(id = 'audit_onlyError_value',label = '差异值设置',value = 0.1,min = 0.1,max = 1.0,step = 0.1)
                                                          )),
                                          
                                    
                                          fluidRow(column(8,mdl_integer(id = 'audit_FI_RPA_Period',label = '月份',min = 1,max = 12,
                                                                        value = as.integer(strsplit(as.character(Sys.Date()),'-')[[1]][2]),step = 1)),
                                                   column(4,checkboxInput(inputId = 'audit_onlyError_btn',label = '仅显示差异项',value = FALSE))
                                                   ),
                                          
                                          
                                          
                                          
                                          
                                          actionButton(inputId = 'audit_FI_RPA_btn',label = '报表反查'),
                                          mdl_download_button(id = 'audit_FI_RPA_dl',label = '下载反查表'),
                                     
                                          
                                )),
                                        column(7, box(
                                          title = "修改区域", width = NULL, solidHeader = TRUE, status = "primary",
                                         
                                          
                                          #添加修改区域
                                          uiOutput('audit_FI_RPA_detail_action')
                                        )
                                        )),
                                        
                                        fluidRow(column(12, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tabBox(title ="",width = 12,
                                                                   id='tabSet_rptTraceBack',height = '800px', 
                                                                   tabPanel('管报反查-品牌选择',tagList(
                                                                     dataTableOutput("audit_FI_RPA_summary")
                                                                   )),
                                                                   tabPanel('管报反查-报表项目',
                                                                            tagList(  div(style = 'overflow-x: scroll',dataTableOutput("audit_FI_RPA_detail")))),
                                                                   tabPanel('管报过程表-SAP凭证',tagList(
                                                                     div(style = 'overflow-x: scroll',dataTableOutput("audit_FI_RPA_detail_SAP")),
                                                                     mdl_download_button(id = 'audit_FI_RPA_detail_SAP_dl',label = '下载SAP凭证数据源')
                                                                   )),
                                                                   tabPanel('管报过程表-BW报表',tagList(
                                                                     div(style = 'overflow-x: scroll',dataTableOutput("audit_FI_RPA_detail_BW")),
                                                                     mdl_download_button(id = 'audit_FI_RPA_detail_BW_dl',label = '下载BW报表数据源')
                                                                   )),
                                                 tabPanel('管报过程表-BW规则表',tagList(
                                                   div(style = 'overflow-x: scroll',dataTableOutput("audit_rule_BW")),
                                                   actionBttn(inputId = "audit_rule_bw_update",label = '修改BW规则表'),
                                                   mdl_download_button(id = 'audit_rule_BW_dl',label = '下载BW规则表')
                                                   
                                                 )),
                                                                   tabPanel('管报过程表-手调凭证',tagList(
                                                                     div(style = 'overflow-x: scroll',dataTableOutput("audit_FI_RPA_detail_ADJ")),
                                                                     mdl_download_button(id = 'audit_FI_RPA_detail_ADJ_dl',label = '下载手调凭证数据源')
                                                                   )),
                                                 tabPanel('1-SAP凭证-分析',tagList(
                                                   fluidRow(column(4,   dragulaInput(
                                                     inputId = "formula_selection",
                                                     label = '聚合函数设置',
                                                     sourceLabel = "可选公式",
                                                     targetsLabels = c("设置公式"),
                                                     replace = TRUE,
                                                     copySource = TRUE,
                                                     selected = list("设置公式" = '求和'),
                                                     choices = c('求和','计数','平均数','最大值','最小值','方差','标准差'),
                                                     width = "300px"
                                                   ),
                                                   #verbatimTextOutput('res_formula_selection'),
                                                    checkboxInput(inputId = 'traceBack_sap_addMargins',label = '分类汇总',value = TRUE),
                                                    actionButton(inputId = 'traceBack_sap_crossTable_run',label = '生成数据透视表'),
                                                   mdl_download_button('traceBack_sap_crossTable_dl','下载透视表')
                                                   
                                                   ),column(8,  
                                                            #生成数据透视表的标签
                                                            uiOutput('col_selection_holder')
                                                            # ,
                                                            # verbatimTextOutput('res_col_selection')
                                              )),
                                                
                                                 
                                                   div(style = 'overflow-x: scroll',dataTableOutput("traceBack_ana_SAP"))
                                                 
                                                
                                                 )),
                                              
                                              tabPanel('2-BW报表-分析',tagList(
                                                fluidRow(column(4,   dragulaInput(
                                                  inputId = "formula_selection_bw",
                                                  label = '聚合函数设置',
                                                  sourceLabel = "可选公式",
                                                  targetsLabels = c("设置公式"),
                                                  replace = TRUE,
                                                  copySource = TRUE,
                                                  selected = list("设置公式" = '求和'),
                                                  choices = c('求和','计数','平均数','最大值','最小值','方差','标准差'),
                                                  width = "300px"
                                                ),
                                                #verbatimTextOutput('res_formula_selection'),
                                                checkboxInput(inputId = 'traceBack_bw_addMargins',label = '分级汇总',value = TRUE),
                                                actionButton(inputId = 'traceBack_bw_crossTable_run',label = '生成数据透视表'),
                                                mdl_download_button('traceBack_bw_crossTable_dl','下载透视表')
                                                
                                                ),column(8,  
                                                         #生成数据透视表的标签
                                                         uiOutput('col_selection_holder_bw')
                                                         # ,
                                                         # verbatimTextOutput('res_col_selection')
                                                )),
                                                
                                                
                                                div(style = 'overflow-x: scroll',dataTableOutput("traceBack_ana_bw"))
                                                
                                                
                                              ))
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   ))))
                                        
                                        
                                        # 
                                        # fluidRow(column(12,box(title = "管报-报表项目", width = NULL, solidHeader = TRUE, status = "primary",
                                        #                       
                                        #                      ''
                                        #                       
                                        #                     
                                        #                        ))
                                        # ),
                                        # 
                                        # 
                                        # fluidRow(column(12,box(title = "过程表-SAP凭证", width = NULL, solidHeader = TRUE, status = "primary",
                                        #                      ))
                                        #          ),
                                        # fluidRow(column(12,box(title = "过程表-手调凭证", width = NULL, solidHeader = TRUE, status = "primary",
                                        #                     ''
                                        #                        ))),
                                        # 
                                        # fluidRow(column(12,box(title = "过程表-BW报表", width = NULL, solidHeader = TRUE, status = "primary",
                                        #                     ''
                                        #                        ))
                                                 
                                                 
                                                 
                                        )),
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
