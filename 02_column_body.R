menu_column <- tabItem(tabName = "column",
                       fluidRow(
                         column(width = 12,
                                tabBox(title ="column工作台",width = 12,
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
                                       tabPanel('sheet2',tagList(
                                         fluidRow(column(4,box(
                                           title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'sheet2'
                                         )),
                                         column(8, box(
                                           title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                           'rpt2'
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