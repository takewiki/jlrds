menu_majority <- tabItem(tabName = "majority",
                         fluidRow(
                           column(width = 12,
                                  tabBox(title ="majority工作台",width = 12,
                                         id='tabSet_majority',height = '300px',
                                         tabPanel('品牌渠道分析',tagList(
                                           fluidRow(column(2,box(
                                             title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                             actionButton(inputId = 'rbu_brandChannel_graph_btn',label = '分析图')
                                           )),
                                           column(10, box(
                                             title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                             
                                             echarts4rOutput('rbu_brandChannel_graph'),
                                             echarts4rOutput('rbu_brandChannel_calc'),
                                             echarts4rOutput('rbu_brandChannel_rollup1'),
                                             echarts4rOutput('rbu_brandChannel_rollup2')
                                             
                                           )
                                           ))
                                           
                                         )),
                                         tabPanel('结构报表中的重复行',tagList(
                                           fluidRow(column(4,box(
                                             title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                             actionButton(inputId = 'mrpt_res_duplicate_btn',label = '检验重复')
                                           )),
                                           column(8, box(
                                             title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                             div(style = 'overflow-x: scroll', mdl_dataTable('mrpt_res_duplicate_dataShow','管报重复性预览'))
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