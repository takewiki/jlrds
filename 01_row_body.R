menu_row <- tabItem(tabName = "row",
                    fluidRow(
                      column(width = 12,
                             tabBox(title ="资金管理工作台",width = 12,
                                    id='tabSet_row',height = '300px',
                                    tabPanel('资金日报查询',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        mdl_dateRange(id = 'daily_dates',label = '日期范围'),
                                        mdl_ListChoose1(id = 'daily_dataRange',label = '数据范围',choiceNames = list('全部','1级','2级'),choiceValues = list(0,1,2),selected =0),
                                        actionButton('daily_preview',label = '查询JALA日报'),
                                        mdl_download_button('daily_dl','下载JALA日报')
                                        
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        
                                       # mdl_dataTable('daily_dataShow','日报数据预览')
                                       
                                       div(style = 'overflow-x: scroll', mdl_dataTable('daily_dataShow','日报数据预览'))
                                       
                                       
                                      )
                                      ))
                                      
                                    )),
                                    tabPanel('资金周报查询',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        mdl_ListChoose1('week_Ftype',label = '周类型',choiceNames = list('伽蓝周(本周二至下周一)','自然周(周一至周日)'),choiceValues = list('jala','nature'),selected = 'jala'
                                                          ),
                                        mdl_numeric(id = 'week_year',label = '年份',value = 2020,min = 2020,max = 2049,step = 1),
                                        
                                        #修改相关数据
                                        uiOutput('weekSelector_ph'),
                                        mdl_ListChoose1(id = 'week_dataRange',label = '数据范围',choiceNames = list('全部','1级','2级'),choiceValues = list(0,1,2),selected =0),
                                        mdl_ListChooseN(id='week_amtType',label = '字段类型',choiceNames = jala_week_amtType,choiceValues = jala_week_amtType,selected = jala_week_amtType[1:3]),
                                        mdl_ListChoose1('week_amount_unit','金额单位:',choiceNames = list('万元','元'),choiceValues = list('wan','yuan'),selected = 'wan'),
                                        actionButton('week_preview',label = '查询JALA周报'),
                                        mdl_download_button('week_dl','下载JALA周报')
                                        
                                        
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        # mdl_dataTable('week_dataShow','周报数据预览')
                                        #add the scrollable 
                                        div(style = 'overflow-x: scroll', mdl_dataTable('week_dataShow','周报数据预览')))
                                      )
                                      )
                                      
                                    )),
                                    tabPanel('资金月报查询',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                 
                                        mdl_numeric(id = 'month_year',label = '年份',value = 2020,min = 2020,max = 2049,step = 1),
                                        
                                  
                                        mdl_ListChoose1(id = 'month_dataRange',label = '数据范围',choiceNames = list('全部','1级','2级'),choiceValues = list(0,1,2),selected =0),
                                        mdl_ListChooseN(id='month_amtType',label = '字段类型',choiceNames = jala_month_amtType,choiceValues = jala_month_amtType,selected = jala_month_amtType[1:3]),
                                        mdl_ListChoose1('month_amount_unit','金额单位:',choiceNames = list('万元','元'),choiceValues = list('wan','yuan'),selected = 'wan'),
                                        actionButton('month_preview',label = '查询JALA月报'),
                                        mdl_download_button('month_dl','下载JALA月报')
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        # mdl_dataTable('month_dataShow','月报数据预览')
                                        
                                        #add the scroll bar
                                        div(style = 'overflow-x: scroll', mdl_dataTable('month_dataShow','月报数据预览'))
                                        
                                        
                                        
                                      )
                                      ))
                                      
                                    )),
                                    tabPanel('资金日报上传',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                         mdl_file('daily_rpt_upload_file',label = '请选择需要上传的日报文件'),
                                         textInput(inputId = 'daily_rpt_sheetName',label = '请选择日报所在页签:',value = 'daily'),
                                         actionButton(inputId = 'daily_upload_btn','上传服务器'),
                                         actionButton(inputId = 'daily_upload_btn_reset','再次激活上传')
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                       'rpt2'
                                      )
                                      ))
                                      
                                    )),
                                    tabPanel('资金周报更新',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        mdl_ListChoose1('week_Ftype_update',label = '周类型',choiceNames = list('伽蓝周(本周二至下周一)','自然周(周一至周日)'),choiceValues = list('jala','nature'),selected = 'jala'
                                        ),
                                        mdl_numeric(id = 'week_year_update',label = '年份',value = 2020,min = 2020,max = 2049,step = 1),
                                        uiOutput('weekSelector_ph_update'),
                                        actionButton(inputId = 'week_update_btn','更新周报'),
                                        actionButton(inputId = 'week_update_btn_reset','再次激活更新')
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        'rpt2'
                                      )
                                      ))
                                      
                                    )),
                                    tabPanel('资金月报更新',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                     
                                        mdl_numeric(id = 'month_year_update',label = '年份',value = 2020,min = 2020,max = 2049,step = 1),
                                        mdl_numeric(id='month_period_update',label = '月份',value=1,min=1,max=12,step=1),
                                        actionButton(inputId = 'month_update_btn','更新月报'),
                                        actionButton(inputId = 'month_update_btn_reset','再次激活更新')
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        'rpt3'
                                      )
                                      ))
                                      
                                    ))
                                    
                                
                              
                                    
                                    
                                    
                             )
                      )
                    )
)
