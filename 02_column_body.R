menu_column <- tabItem(tabName = "column",
                       fluidRow(
                         column(width = 12,
                                tabBox(title ="管报工作台",width = 12,
                                       id='tabSet_column',height = '300px',
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