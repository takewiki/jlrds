menu_column <- tabItem(tabName = "column",
                       fluidRow(
                         column(width = 12,
                                tabBox(title ="管报工作台",width = 12,
                                       id='tabSet_column',height = '300px',
                                
                                 
                                       tabPanel('1.01品牌渠道事业部',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4("说明：1.定义了品牌与渠道;2.定义了品牌与事业部的关系;3.定义了品牌渠道的2个描述性名称,用于成本中心的渠道费用分配;4.定义了虚拟的市场类型的渠道，用于市场费用的二次分配"),
                                          br(),
                                          tags$h4("用途:1.使用了[描述1]字段生成渠道费用分配表2.根据渠道渠道找到相应事业部的定义"),
                                          br(),
                                          hr(),
                                          # tags$h4('元数据信息'),
                                          # h4('R：jlrdspkg::mrpt_md_ui_division(conn = conn)'),
                                          # h4('Loc: R/mrpt02_sap_ui.R'),
                                          # h4('SQL: select * from t_mrpt_division'),
                                          
                                           actionButton('md_division_preview',label = '查询事业部'),
                                           mdl_download_button('md_division_dl','下载事业部'),
                                          br(),
                                          hr(),
                                          tags$a(href='品牌渠道事业部模板.xlsx','第一次使用，请下载品牌渠道事业部模板'),
                                          br(),
                                          mdl_file('md_division_preview_file','请选择品牌渠道事业部定义文件'),
                                          actionButton('md_division_upload',label = '上传品牌渠道事业部定义')
                                          
                                          
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_division_dataShow','事业部数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('1.02成本中心',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4('说明：1.用于根据成本中心带出品牌及渠道2.根据成本中心带出渠道费用的分配比例'),
                                           br(),
                                           hr(),
                                          mdl_text(id = 'md_costCenter_FYear',label = '年份'),
                                          mdl_text(id='md_costCenter_FPeriod',label = '月份'),
                                          actionButton('md_costCenter_preview',label = '查询成本中心'),
                                          mdl_download_button('md_costCenter_dl','下载成本中心'),
                                          br(),
                                          hr(),
                                          tags$a(href='成本中心划分及渠道费用分配表模板.xlsx','第一次使用，请下载成本中心划分及渠道费用分配表模板'),
                                          tags$h4('注意选择上述的年份与月份，将作为新上传的年月生效信息。'),
                                          mdl_file('md_costCenter_file','请选择一个成本中心文件'),
                                          actionButton('md_costCenter_upload','上传成本中心')
                                          
                                           
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_costCenter_dataShow','成本中心数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('1.03成本要素',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4('说明:1.定义了成本要素与报表项目之间的相对关系2.不是直接费用，而是采用统一的费用名称然后再结合成本中心的渠道与市场费用一起才能发生使用。'),
                                           br(),
                                           hr(),
                                           mdl_text(id = 'itemMap_FYear',label = '年份'),
                                           mdl_text(id='itemMap_FPeriod',label = '月份'),
                                           actionButton('itemMap_preview',label = '查询对照表'),
                                           mdl_download_button('itemMap_dl','下载对应表'),
                                           br(),
                                           hr(),
                                           tags$a(href='成本要素模板.xlsx','第一次使用，请下载成本要素模板'),
                                           tags$h4('注意选择上述的年份与月份，将作为新上传的年月生效信息。'),
                                           mdl_file('itemMap_file','请选择一个成本要素文件'),
                                           actionButton('itemMap_upload','上传成本要素')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('itemMap_dataShow','成本项目与报表项目数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('1.04报表项目',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4("说明：1.定义的标准的报表项目2.定义了报表项目与统一费用名称及渠道类型的关系"),
                                           br(),
                                           tags$h4("用途:与成本项目之间使用对象的关系"),
                                           br(),
                                           hr(),
                                           actionButton('md_rptItem_preview',label = '查询报表项目'),
                                           mdl_download_button('md_rptItem_dl','下载报表项目'),
                                           br(),
                                           hr(),
                                           tags$a(href='报表项目模板.xlsx','第一次使用，请下载报表项目模板'),
                                           mdl_file('md_rptItem_file','请选择一下报表项目文件'),
                                           actionButton('md_rptItem_upload',label = '上传报表项目'),
                                           
                                           
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_rptItem_dataShow','报表项目数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('1.05BW指标',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4('说明:1.BW报表固定报头,其实是指标，所有方案原则上一致2.可以用于存储数据源3.目前15项数据源'),
                                           br(),
                                           tags$h4("用途：1.用于对数据源BW报表的处理2.所有数据源的功能需要迁移到RPA中; 3.用于支持数据的反向追溯"),
                                           br(),
                                           hr(),
                                           actionButton('md_bw_Heading_preview',label = '查询BW表头'),
                                           mdl_download_button('md_bw_Heading_dl','下载BW表头')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_bw_Heading_dataShow','BW指标固定表头数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('1.06BW维度',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4("说明：1.每个方案对应的变动表头不一致2.变动表头影响后续业务分析3.应该使用所有变动表头的最大集处理数据源4.目前采用的方式有待改进。"),
                                           br(),
                                           tags$h4("用途：1.用于对数据源BW报表的处理2.所有数据源的功能需要迁移到RPA中; 3.用于支持数据的反向追溯"),
                                           br(),
                                           tags$h4("备注：目前没有发现有什么关系"),
                                           br(),
                                           hr(),
                                           actionButton('md_bw_dim_preview',label = '查询BW维度'),
                                           mdl_download_button('md_bw_dim_dl','下载BW维度'),
                                           br(),
                                           hr(),
                                           tags$a(href='BW维度模板.xlsx','第一次使用，请下载BW维度模板'),
                                           mdl_file('md_bw_dim_file','请选择一下BW报表维度文件'),
                                           actionButton('md_bw_dim_upload',label = '上传BW报表维度'),
                                           
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_bw_dim_dataShow','BW维度变动表头数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('1.07BW报表业务规则',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4("说明:1.定义了BW指标固定表头与报表项目的关系2.多个方案号才能表达一个完整的指标固定表头"),
                                           br(),
                                           hr(),
                                           actionButton('md_bw_businessRule_preview',label = '查询BW报表业务规则'),
                                           mdl_download_button('md_bw_businessRule_dl','下载BW报表业务规则'),
                                           br(),
                                           hr(),
                                           tags$a(href='BW报表业务规则模板.xlsx','第一次使用，请下载BW报表业务规则模板'),
                                           mdl_file('md_bw_businessRule_file','请选择一下BW报表业务规则文件'),
                                           actionButton('md_bw_businessRule_upload',label = '上传BW报表业务规则')
                                           
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_bw_businessRule_dataShow','BW业务规则数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('1.08客户折扣',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4('规则表-珀芙研客户折扣清单,未指定渠道,客户名称待核验'),
                                           tags$h4('规则表-自然堂电商客户折扣清单，客户名称待核验'),
                                           tags$h4('规则表-春夏电商客户折扣清单，客户名称待核验'),
                                           br(),
                                           hr(),
                                           mdl_text(id='md_discount_FBrand',label = '品牌'),
                                           actionButton('md_discount_preview',label = '查询客户折扣清单'),
                                           mdl_download_button('md_discount_dl','客户折扣清单')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_discount_dataShow','客户折扣清单数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       
                                       tabPanel('1.09自然堂电商科目及报表项目对照表',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                         
                                           tags$a(href='自然堂电商科目及报表项目对照表模板.xlsx','第一次使用，请下载自然堂电商科目与报表项目对照表模板'),
                                          
                                           mdl_file(id = 'md_chando_eCom_acctRpt_mapping_file',label = '请选择对照表'),
                                           
                                           
                                           actionButton('md_chando_eCom_acctRpt_mapping_upload','上传对照表'),
                                           actionButton('md_chando_eCom_acctRpt_mapping_query','查看对照表')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_chando_eCom_acctRpt_mapping_dataShow','对照表数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('1.10重分类与科目对照表',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           actionButton('md_reClassifyAcct_mapping_query','查看对照表'),
                                           mdl_download_button('md_reClassifyAcct_mapping_dl','下载对照表'),
                                           br(),
                                           hr(),
                                           
                                           tags$a(href='重分类及科目对照表模板.xlsx','第一次使用，请下载重分类及科目对照表模板'),
                                           tags$h4('目前使用科目代码匹配，科目名称可以选填'),
                                           
                                           mdl_file(id = 'md_reClassifyAcct_mapping_file',label = '请选择对照表文件'),
                                           
                                           
                                           actionButton('md_reClassifyAcct_mapping_upload','上传对照表'),
                                        
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_reClassifyAcct_mapping_dataShow','对照表数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('2.01A数据源-历史数据-上传[品牌渠道]',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           
                                           selectInput('actual_FBrand_upload1',label = '请选择品牌',
                                                       choices  = jlrdspkg::mrpt_md_brand()),
                                           
                                           
                                           mdl_ListChooseN(id = 'actual_FChannel_upload1',label = '请选择至少一个渠道',
                                                           choiceNames = jlrdspkg::mrpt_md_channel(),
                                                           choiceValues = jlrdspkg::mrpt_md_channel()
                                           ),
                                           mdl_text(id='actual_FYear_upload1',label = '年'),
                                           mdl_text(id='actual_FPeriod_upload1',label = '月'),
                                           mdl_ListChoose1(id = 'actual_upload_type1',label = '月份类型',choiceNames = list('当月数','1月至当前月'),choiceValues = (list(TRUE,FALSE))),
                                           br(),
                                           
                                           tags$a(href='历史数据模板.xlsx','第一次使用，请下载历史数据模板'),
                                           tags$h4('注意上传的历史数据的页签必须与上述选择的渠道名称保持一致，否则上传失败'),
                                           mdl_file(id = 'actual_upload_file1',label = '请选择历史数据'),
                                           
                                           
                                           actionButton('actual_upload_done1','上传历史数据')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('actual_upload_dataShow1','历史数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('2.01B数据源-历史数据-上传[子渠道]',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           selectInput( 'actual_FChannel_upload_sub2',label = '请选择至少一个渠道',
                                                        choices  = jlrdspkg::mrpt_md_channel2()),
                                           mdl_ListChooseN(id = 'actual_FChannel_upload_sub2',label = '请选择至少一个子渠道',
                                                           choiceNames = jlrdspkg::mrpt_md_subChannel(),
                                                           choiceValues = jlrdspkg::mrpt_md_subChannel()
                                           ),
                                           
                                           selectInput('actual_FBrand_upload_sub2',label = '适用品牌',
                                                       choices  = jlrdspkg::mrpt_md_brand()),
                                           
                                           
                                           
                                           mdl_text(id='actual_FYear_upload_sub2',label = '年'),
                                           mdl_text(id='actual_FPeriod_upload_sub2',label = '月'),
                                           mdl_ListChoose1(id = 'actual_upload_type_sub2',label = '月份类型',choiceNames = list('当月数','1月至当前月'),choiceValues = (list(TRUE,FALSE))),
                                           br(),
                                           tags$a(href='历史数据模板 - 子渠道.xlsx','第一次使用，请下载子渠道历史数据模板'),
                                           tags$h4('注意上传的历史数据数据的页签必须与上述选择的子渠道名称保持一致，否则上传失败'),
                                           mdl_file(id = 'actual_upload_file_sub2',label = '请选择历史数据'),
                                           
                                           
                                           actionButton('actual_upload_done_sub2','上传历史数据')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('actual_upload_sub_dataShow2','历史数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                      
                                       tabPanel('2.01C数据源-历史数据-查询',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           mdl_text(id='actual_FBrand',label = '品牌'),
                                           mdl_text(id='actual_FChannel',label = '渠道'),
                                           mdl_text(id='actual_FYear',label = '年'),
                                           mdl_text(id='actual_FPeriod',label = '月'),
                                           actionButton('actual_preview',label = '预览历史数据'),
                                           mdl_download_button('actual_dl','下载历史数据')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('actual_dataShow','历史数据数据预览'))
                                         )
                                         ))
                                         
                                       ))
                                       ,
                                       tabPanel('2.02数据源-SAP数据查询',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           mdl_text(id = 'ds_sap_FYear',label = '年份'),
                                           mdl_text(id='ds_sap_FPeriod',label = '月份'),
                                           actionButton('ds_sap_preview',label = '查询SAP数据'),
                                           mdl_download_button('ds_sap_dl','下载SAP数据')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('ds_sap_dataShow','SAP数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                 
                                 
                                      
                                       tabPanel('2.03数据源-BW数据',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           mdl_text(id = 'ds_bw_FYear',label = '年份'),
                                           mdl_text(id='ds_bw_FPeriod',label = '月份'),
                                           actionButton('ds_bw_preview',label = '查询BW数据'),
                                           mdl_download_button('ds_bw_dl','下载BW数据')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('ds_bw_dataShow','BW数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('2.04数据源-手工调整',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           mdl_text(id = 'adj_FYear',label = '年份'),
                                           mdl_text(id='adj_FPeriod',label = '月份'),
                                           actionButton('adj_preview',label = '查询手工调整数据'),
                                           mdl_download_button('adj_dl','下载手工调整')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('adj_dataShow','手工调整数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('2.05A数据源-执行预算-上传[品牌渠道]',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           
                                           selectInput('budget_FBrand_upload',label = '请选择品牌',
                                                           choices  = jlrdspkg::mrpt_md_brand()),
                                                           
                      
                                           mdl_ListChooseN(id = 'budget_FChannel_upload',label = '请选择至少一个渠道',
                                                           choiceNames = jlrdspkg::mrpt_md_channel(),
                                                           choiceValues = jlrdspkg::mrpt_md_channel()
                                                          ),
                                           mdl_text(id='budget_FYear_upload',label = '年'),
                                           mdl_text(id='budget_FPeriod_upload',label = '月'),
                                           mdl_ListChoose1(id = 'budget_upload_type',label = '月份类型',choiceNames = list('当月数','1月至当前月'),choiceValues = (list(TRUE,FALSE))),
                                           br(),
                                          
                                           tags$a(href='执行预算模板.xlsx','第一次使用，请下载执行预算模板'),
                                           tags$h4('注意上传的执行预算数据的页签必须与上述选择的渠道名称保持一致，否则上传失败'),
                                           mdl_file(id = 'budget_upload_file',label = '请选择执行预算'),
                                           
                                         
                                           actionButton('budget_upload_done','上传执行预算')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('budget_upload_dataShow','执行预算数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('2.05B数据源-执行预算-上传[子渠道]',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           selectInput( 'budget_FChannel_upload_sub',label = '请选择至少一个渠道',
                                                       choices  = jlrdspkg::mrpt_md_channel2()),
                                           mdl_ListChooseN(id = 'budget_FChannel_upload_sub2',label = '请选择至少一个子渠道',
                                                           choiceNames = jlrdspkg::mrpt_md_subChannel(),
                                                           choiceValues = jlrdspkg::mrpt_md_subChannel()
                                           ),
                                           
                                           selectInput('budget_FBrand_upload_sub',label = '适用品牌',
                                                       choices  = jlrdspkg::mrpt_md_brand()),
                                           
                                           
                                          
                                           mdl_text(id='budget_FYear_upload_sub',label = '年'),
                                           mdl_text(id='budget_FPeriod_upload_sub',label = '月'),
                                           mdl_ListChoose1(id = 'budget_upload_type_sub',label = '月份类型',choiceNames = list('当月数','1月至当前月'),choiceValues = (list(TRUE,FALSE))),
                                           br(),
                                           tags$a(href='执行预算模板 - 子渠道.xlsx','第一次使用，请下载子渠道执行预算模板'),
                                           tags$h4('注意上传的执行预算数据的页签必须与上述选择的子渠道名称保持一致，否则上传失败'),
                                           mdl_file(id = 'budget_upload_file_sub',label = '请选择执行预算'),
                                           
                                     
                                           actionButton('budget_upload_done_sub','上传执行预算')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('budget_upload_sub_dataShow','执行预算数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('2.05C数据源-执行预算-查询',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           mdl_text(id='budget_FBrand',label = '品牌'),
                                           mdl_text(id='budget_FChannel',label = '渠道'),
                                          
                                           mdl_text(id='budget_FYear',label = '年'),
                                           mdl_text(id='budget_FPeriod',label = '月'),
                                  
                                       
                                           
                                           actionButton('budget_preview',label = '预览执行预算'),
                                           mdl_download_button('budget_dl','下载执行预算')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('budget_dataShow','执行预算数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                    
                                       tabPanel('2.06数据源-平板数据',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'sheet4'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt4'
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('2.07数据源-回款数据',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'sheet4'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt4'
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('2.08数据源-零售指标数据',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'sheet4'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt4'
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('2.09数据源-NKA数据',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'sheet4'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt4'
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('2.10数据源-经营快报',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           '每月3日左右提供'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt4'
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('3.01结果表-品牌',tagList(
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
                                       tabPanel('3.02结果表-事业部',tagList(
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
                                       tabPanel('3.03结果表-集团',tagList(
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
                               
                                       tabPanel('4.01处理表-SAP',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           mdl_text(id='sap_deal_FBrand',label = '品牌'),
                                           mdl_text(id='sap_deal_FChannel',label = '渠道'),
                                           mdl_text(id='sap_deal_FYear',label = '年'),
                                           mdl_text(id='sap_deal_FPeriod',label = '月'),
                                           actionButton('sap_deal_preview',label = '预览SAP处理中间表'),
                                           mdl_download_button('sap_deal_dl','下载SAP处理中间表')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('sap_deal_dataShow','SAP处理中间表数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('4.02处理表-BW',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           mdl_text(id='bw_deal_FBrand',label = '品牌'),
                                           mdl_text(id='bw_deal_FChannel',label = '渠道'),
                                           mdl_text(id='bw_deal_FYear',label = '年'),
                                           mdl_text(id='bw_deal_FPeriod',label = '月'),
                                           actionButton('bw_deal_preview',label = '预览BW处理中间表'),
                                           mdl_download_button('bw_deal_dl','下载BW处理中间表')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('bw_deal_dataShow','BW处理中间表数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('4.03处理表-手调',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           mdl_text(id='adj_deal_FBrand',label = '品牌'),
                                           mdl_text(id='adj_deal_FChannel',label = '渠道'),
                                           mdl_text(id='adj_deal_FYear',label = '年'),
                                           mdl_text(id='adj_deal_FPeriod',label = '月'),
                                           actionButton('adj_deal_preview',label = '预览手工调整中间表'),
                                           mdl_download_button('adj_deal_dl','下载手工调整中间表')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('adj_deal_dataShow','手工调整中间表数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('4.04处理表-回款指标',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'sheet4'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt4'
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('4.05处理表-公司零售额',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'sheet4'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt4'
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('4.06处理表-其他指标计算',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'sheet4'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt4'
                                         )
                                         ))
                                         
                                       )),
                                   
                                       tabPanel('5.01反查表-品牌渠道',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'sheet4'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt4'
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('5.02反查表-事业部',tagList(
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