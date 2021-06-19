menu_column <- tabItem(tabName = "column",
                       fluidRow(
                         column(width = 12,
                                tabBox(title ="管报工作台",width = 12,
                                       id='tabSet_column',height = '300px',
                                
                                 
                                       tabPanel('事业部定义',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
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
                                       tabPanel('成本项目与报表项目对应表',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
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
                                       tabPanel('报表项目',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
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
                                           actionButton('md_bw_dim_preview',label = '查询BW维度变动表头'),
                                           mdl_download_button('md_bw_dim_dl','下载BW维度变动表头')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_bw_dim_dataShow','BW维度变动表头数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('BW报表取数规则',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           actionButton('md_bw_businessRule_preview',label = '查询BW报表业务规则'),
                                           mdl_download_button('md_bw_businessRule_dl','下载BW报表业务规则')
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           div(style = 'overflow-x: scroll', mdl_dataTable('md_bw_businessRule_dataShow','BW业务规则数据预览'))
                                         )
                                         ))
                                         
                                       )),
                                       tabPanel('规则表-珀芙研供应商折扣清单',tagList(
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
                                       tabPanel('规则表-自然堂电商供应商折扣清单',tagList(
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
                                       tabPanel('规则表-春夏电商供应商折扣清单',tagList(
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
                                       tabPanel('数据源-历史数据',tagList(
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
                                           'sheet3'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt3'
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