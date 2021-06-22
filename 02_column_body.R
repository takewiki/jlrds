menu_column <- tabItem(tabName = "column",
                       fluidRow(
                         column(width = 12,
                                tabBox(title ="管报工作台",width = 12,
                                       id='tabSet_column',height = '300px',
                                
                                 
                                       tabPanel('品牌渠道及事业部的定义',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4("说明：1.定义了品牌与渠道;2.定义了品牌与事业部的关系;3.定义了品牌渠道的2个描述性名称,用于成本中心的渠道费用分配;4.定义了虚拟的市场类型的渠道，用于市场费用的二次分配"),
                                          br(),
                                          tags$h4("用途:1.使用了[描述1]字段生成渠道费用分配表2.根据渠道渠道找到相应事业部的定义"),
                                          br(),
                                          hr(),
                                           actionButton('md_division_preview',label = '查询事业部'),
                                           mdl_download_button('md_division_dl','下载事业部')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_division_dataShow','事业部数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('成本中心划分及渠道费用分配表',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4('说明：1.用于根据成本中心带出品牌及渠道2.根据成本中心带出渠道费用的分配比例'),
                                           br(),
                                           hr(),
                                          mdl_text(id = 'md_costCenter_FYear',label = '年份'),
                                          mdl_text(id='md_costCenter_FPeriod',label = '月份'),
                                          actionButton('md_costCenter_preview',label = '查询成本中心'),
                                          mdl_download_button('md_costCenter_dl','下载成本中心')
                                          
                                           
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_costCenter_dataShow','成本中心数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('成本要素与统一费用名称对应表',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4('说明:1.定义了成本要素与报表项目之间的相对关系2.不是直接费用，而是采用统一的费用名称然后再结合成本中心的渠道与市场费用一起才能发生使用。'),
                                           br(),
                                           hr(),
                                           mdl_text(id = 'itemMap_FYear',label = '年份'),
                                           mdl_text(id='itemMap_FPeriod',label = '月份'),
                                           actionButton('itemMap_preview',label = '查询对照表'),
                                           mdl_download_button('itemMap_dl','下载对应表')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('itemMap_dataShow','成本项目与报表项目数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('报表项目及统一费用名称对应表',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4("说明：1.定义的标准的报表项目2.定义了报表项目与统一费用名称及渠道类型的关系"),
                                           br(),
                                           tags$h4("用途:与成本项目之间使用对象的关系"),
                                           br(),
                                           hr(),
                                           actionButton('md_rptItem_preview',label = '查询报表项目'),
                                           mdl_download_button('md_rptItem_dl','下载报表项目')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_rptItem_dataShow','报表项目数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('BW指标固定表头',tagList(
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
                                       tabPanel('BW维度变动表头',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4("说明：1.每个方案对应的变动表头不一致2.变动表头影响后续业务分析3.应该使用所有变动表头的最大集处理数据源4.目前采用的方式有待改进。"),
                                           br(),
                                           tags$h4("用途：1.用于对数据源BW报表的处理2.所有数据源的功能需要迁移到RPA中; 3.用于支持数据的反向追溯"),
                                           br(),
                                           tags$h4("备注：目前没有发现有什么关系"),
                                           br(),
                                           hr(),
                                           actionButton('md_bw_dim_preview',label = '查询BW维度变动表头'),
                                           mdl_download_button('md_bw_dim_dl','下载BW维度变动表头')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_bw_dim_dataShow','BW维度变动表头数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('BW报表取数规则:指标固定表头与报表项目对应关系',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           tags$h4("说明:1.定义了BW指标固定表头与报表项目的关系2.多个方案号才能表达一个完整的指标固定表头"),
                                           br(),
                                           hr(),
                                           actionButton('md_bw_businessRule_preview',label = '查询BW报表业务规则'),
                                           mdl_download_button('md_bw_businessRule_dl','下载BW报表业务规则')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_bw_businessRule_dataShow','BW业务规则数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('规则表-客户折扣清单(整合后)',tagList(
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
                                      
                                       tabPanel('数据源-历史数据',tagList(
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
                                         
                                       )),
                                       tabPanel('数据源-SAP数据查询',tagList(
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
                                 
                                 
                                      
                                       tabPanel('数据源-BW数据',tagList(
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
                                       tabPanel('数据源-手工调整',tagList(
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
                                       tabPanel('数据源-执行预算',tagList(
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
                                       tabPanel('数据源-平板数据',tagList(
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
                                       tabPanel('数据源-回款数据',tagList(
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
                                       tabPanel('数据源-零售指标数据',tagList(
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
                                       tabPanel('数据源-NKA数据',tagList(
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
                                       tabPanel('结果表-品牌',tagList(
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
                                       tabPanel('结果表-事业部',tagList(
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
                                       tabPanel('结果表-集团',tagList(
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
                               
                                       tabPanel('处理表-SAP',tagList(
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
                                       tabPanel('处理表-BW',tagList(
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
                                       tabPanel('处理表-手调',tagList(
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
                                       tabPanel('处理表-回款指标',tagList(
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
                                       tabPanel('处理表-公司零售额',tagList(
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
                                       tabPanel('处理表-其他指标计算',tagList(
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
                                       tabPanel('处理表-横向拼接',tagList(
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
                                       tabPanel('反查表-品牌渠道',tagList(
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
                                       tabPanel('反查表-事业部',tagList(
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