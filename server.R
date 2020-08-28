

#shinyserver start point----
 shinyServer(function(input, output,session) {
    #00-基础框设置-------------
    #读取用户列表
    user_base <- getUsers(conn_be,app_id)
    
    
    
    credentials <- callModule(shinyauthr::login, "login", 
                              data = user_base,
                              user_col = Fuser,
                              pwd_col = Fpassword,
                              hashed = TRUE,
                              algo = "md5",
                              log_out = reactive(logout_init()))
    
    
    
    logout_init <- callModule(shinyauthr::logout, "logout", reactive(credentials()$user_auth))
    
    observe({
       if(credentials()$user_auth) {
          shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
       } else {
          shinyjs::addClass(selector = "body", class = "sidebar-collapse")
       }
    })
    
    user_info <- reactive({credentials()$info})
    
    #显示用户信息
    output$show_user <- renderUI({
       req(credentials()$user_auth)
       
       dropdownButton(
          fluidRow(  box(
             title = NULL, status = "primary", width = 12,solidHeader = FALSE,
             collapsible = FALSE,collapsed = FALSE,background = 'black',
             #2.01.01工具栏选项--------
             
             
             actionLink('cu_updatePwd',label ='修改密码',icon = icon('gear') ),
             br(),
             br(),
             actionLink('cu_UserInfo',label = '用户信息',icon = icon('address-card')),
             br(),
             br(),
             actionLink(inputId = "closeCuMenu",
                        label = "关闭菜单",icon =icon('window-close' ))
             
             
          )) 
          ,
          circle = FALSE, status = "primary", icon = icon("user"), width = "100px",
          tooltip = FALSE,label = user_info()$Fuser,right = TRUE,inputId = 'UserDropDownMenu'
       )
       #
       
       
    })
    
    observeEvent(input$closeCuMenu,{
       toggleDropdownButton(inputId = "UserDropDownMenu")
    }
    )
    
    #修改密码
    observeEvent(input$cu_updatePwd,{
       req(credentials()$user_auth)
       
       showModal(modalDialog(title = paste0("修改",user_info()$Fuser,"登录密码"),
                             
                             mdl_password('cu_originalPwd',label = '输入原密码'),
                             mdl_password('cu_setNewPwd',label = '输入新密码'),
                             mdl_password('cu_RepNewPwd',label = '重复新密码'),
                             
                             footer = column(shiny::modalButton('取消'),
                                             shiny::actionButton('cu_savePassword', '保存'),
                                             width=12),
                             size = 'm'
       ))
    })
    
    #处理密码修改
    
    var_originalPwd <-var_password('cu_originalPwd')
    var_setNewPwd <- var_password('cu_setNewPwd')
    var_RepNewPwd <- var_password('cu_RepNewPwd')
    
    observeEvent(input$cu_savePassword,{
       req(credentials()$user_auth)
       #获取用户参数并进行加密处理
       var_originalPwd <- password_md5(var_originalPwd())
       var_setNewPwd <-password_md5(var_setNewPwd())
       var_RepNewPwd <- password_md5(var_RepNewPwd())
       check_originalPwd <- password_checkOriginal(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_originalPwd)
       check_newPwd <- password_equal(var_setNewPwd,var_RepNewPwd)
       if(check_originalPwd){
          #原始密码正确
          #进一步处理
          if(check_newPwd){
             password_setNew(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_setNewPwd)
             pop_notice('新密码设置成功:)') 
             shiny::removeModal()
             
          }else{
             pop_notice('两次输入的密码不一致，请重试:(') 
          }
          
          
       }else{
          pop_notice('原始密码不对，请重试:(')
       }
       
       
       
       
       
    }
    )
    
    
    
    #查看用户信息
    
    #修改密码
    observeEvent(input$cu_UserInfo,{
       req(credentials()$user_auth)
       
       user_detail <-function(fkey){
          res <-tsui::userQueryField(conn = conn_be,app_id = app_id,user =user_info()$Fuser,key = fkey)
          return(res)
       } 
       
       
       showModal(modalDialog(title = paste0("查看",user_info()$Fuser,"用户信息"),
                             
                             textInput('cu_info_name',label = '姓名:',value =user_info()$Fname ),
                             textInput('cu_info_role',label = '角色:',value =user_info()$Fpermissions ),
                             textInput('cu_info_email',label = '邮箱:',value =user_detail('Femail') ),
                             textInput('cu_info_phone',label = '手机:',value =user_detail('Fphone') ),
                             textInput('cu_info_rpa',label = 'RPA账号:',value =user_detail('Frpa') ),
                             textInput('cu_info_dept',label = '部门:',value =user_detail('Fdepartment') ),
                             textInput('cu_info_company',label = '公司:',value =user_detail('Fcompany') ),
                             
                             
                             footer = column(shiny::modalButton('确认(不保存修改)'),
                                             
                                             width=12),
                             size = 'm'
       ))
    })
    
    
    
    #针对用户信息进行处理
    
    sidebarMenu <- reactive({
       
       res <- setSideBarMenu(conn_rds('rdbe'),app_id,user_info()$Fpermissions)
       return(res)
    })
    
    
    #针对侧边栏进行控制
    output$show_sidebarMenu <- renderUI({
       if(credentials()$user_auth){
          return(sidebarMenu())
       } else{
          return(NULL) 
       }
       
       
    })
    
    #针对工作区进行控制
    output$show_workAreaSetting <- renderUI({
       if(credentials()$user_auth){
          return(workAreaSetting)
       } else{
          return(NULL) 
       }
       
       
    })
   
   
   #JALA日报-------
    var_daily_dates <- var_dateRange('daily_dates')
    var_level <- var_ListChoose1('daily_dataRange')
    
    data_daily <- eventReactive(input$daily_preview,{
      dates <-var_daily_dates()
      startDate <- as.character(dates[1])
      endDate <- as.character(dates[2])
      level <- var_level()
      data <- jlrdspkg::rpt_daily_selectDb(conn=conn,FStartDate =startDate ,FEndDate =endDate ,FLevel =level )
      return(data)
    })
    
    observeEvent(input$daily_preview,{
      data <- data_daily()
      run_dataTable2('daily_dataShow',data = data)
      run_download_xlsx('daily_dl',data = data,filename = 'JALA日报.xlsx')
    })
   
    #上传周报数据-----
    
    var_daily_rpt_upload_file <- var_file('daily_rpt_upload_file')
    observeEvent(input$daily_upload_btn,{
      shinyjs::disable('daily_upload_btn')
      file <-var_daily_rpt_upload_file()
      jlrdspkg::rpt_daily_writeDb(file=file,sheet = input$daily_rpt_sheetName,conn = conn)
      pop_notice('资金日报数据已上传')
      
    })
    
    #再次激活
    observeEvent(input$daily_upload_btn_reset,{
      shinyjs::enable('daily_upload_btn')
    })
    
    #处理周报数据
    #年
    var_week_year <- var_numeric('week_year')
    #处理开始周与结束周
    #var_startWeekNo <-
    #var_endWeekNo <-
    #周类型
    var_week_Ftype <- var_ListChoose1('week_Ftype')
    #数据范围
    var_week_dataRange <- var_ListChoose1('week_dataRange')
    #字段类型
    var_week_amtType <- var_ListChooseN('week_amtType')
    output$weekSelector_ph <- renderPrint({
      week_year <- var_week_year()
      week_Ftype <- var_week_Ftype()
      week_info <- jlrdspkg::week_getDateList(conn=conn,year = week_year,Ftype = week_Ftype)
      #print(week_info)
      #selectInput(inputId = 'weekEndNo',label = '结束周号',choices = week_info)
      
      tagList(
        selectInput(inputId = 'weekStartNo',label = '开始周号',choices = week_info),
        selectInput(inputId = 'weekEndNo',label = '结束周号',choices = week_info)
      )
     })
    
    #处理周报数据------
    var_week_amtUnit <- var_ListChoose1('week_amount_unit')
    observeEvent(input$week_preview,{
      week_year <-var_week_year()
      print(week_year)
      week_Ftype <- var_week_Ftype()
      print(week_Ftype)
      week_startNo <- as.integer(input$weekStartNo)
      print(week_startNo)
      week_endNo <- as.integer(input$weekEndNo)
      print(week_endNo)
      week_amtType  <-var_week_amtType()
      print(week_amtType)
      week_FLevel <- as.integer(var_week_dataRange())
      print(week_FLevel)
      #处理金额单位
      week_amtUnit = var_week_amtUnit()
      
      data <- tryCatch(
        {jlrdspkg::weekRpt_selectDB(conn=conn,year = week_year,startWeekNo = week_startNo,
                                         endWeekNo = week_endNo,AmtType = week_amtType,FLevel = week_FLevel,
                                         FType = week_Ftype,Amt_Unit=week_amtUnit)},error =function(e){
                                           res <-data.frame(`错误提示`="请检查一下开始周次与结束周次是否正确")
                                           return(res)
                                         })
      #显示周报
      run_dataTable2('week_dataShow',data = data)
      #下载周报
      run_download_xlsx('week_dl',data = data,filename = '周报数据下载.xlsx')
      
      
      
      
    })
    #处理月报------
    var_month_year <- var_numeric('month_year')
  
    #数据范围
    var_month_dataRange <- var_ListChoose1('month_dataRange')
    #字段类型
    var_month_amtType <- var_ListChooseN('month_amtType')
    var_month_amtUnit <- var_ListChoose1('month_amount_unit')
    
    observeEvent(input$month_preview,{
      month_year <-var_month_year()
      print(month_year)
      
      month_amtType  <-var_month_amtType()
      print(month_amtType)
      month_FLevel <- as.integer(var_month_dataRange())
      print(month_FLevel)
      #金额单位
      month_amtUnit <- var_month_amtUnit()
      
      data <- tryCatch(
        {jlrdspkg::monthRpt_selectDB(conn=conn,year = month_year,AmtType = month_amtType,FLevel = month_FLevel,amtUnit =month_amtUnit )},error =function(e){
                                      res <-data.frame(`错误提示`="请检查一下参数是否正确")
                                      return(res)
                                    })
      #显示周报
      run_dataTable2('month_dataShow',data = data)
      #下载周报
      run_download_xlsx('month_dl',data = data,filename = '月报数据下载.xlsx')
      
      
      
      
    })
    
    #处理周报更新-----
    var_week_year_update <- var_numeric('week_year_update')
   
    #周类型
    var_week_Ftype_update <- var_ListChoose1('week_Ftype_update')
    
    output$weekSelector_ph_update <- renderPrint({
      week_year <- var_week_year_update()
      week_Ftype <- var_week_Ftype_update()
      week_info <- jlrdspkg::week_getDateList(conn=conn,year = week_year,Ftype = week_Ftype)
     
      
      tagList(
        selectInput(inputId = 'weekNo_update',label = '选择需要更新的周号',choices = week_info)
      )
    })
    
    observeEvent(input$week_update_btn,{
      shinyjs::disable('week_update_btn')
      week_year <- var_week_year_update()
      week_year <- as.integer(week_year)
      week_Ftype <- var_week_Ftype_update()
      weekNo <- input$weekNo_update
      weekNo <- as.integer(weekNo)
      # try({
      #   jlrdspkg::week_deal(conn=conn,year=week_year,weekNo = weekNo,type = week_Ftype)
      #   jlrdspkg::week_stat(conn=conn,year=week_year,weekNo = weekNo,type = week_Ftype)
      # })
      
      try(
        jlrdspkg::week_update(conn=conn,Fyear = week_year,FweekNo = weekNo,Ftype = week_Ftype)
      )
      pop_notice('周报已更新')
      
      
    })
    observeEvent(input$week_update_btn_reset,{
      
    shinyjs::enable('week_update_btn')
    })
    
    #月报更新----
    var_month_year_update <- var_numeric('month_year_update')
    var_month_period_update <- var_numeric('month_period_update')
    observeEvent(input$month_update_btn,{
      shinyjs::disable('month_update_btn')
      month_year <- as.integer(var_month_year_update())
      month_period <- as.integer(var_month_period_update())
      try({
        jlrdspkg::month_update(conn=conn,Fyear = month_year,Fmonth = month_period)
      })
      pop_notice('月报更新完成！')
      
      
    })
    
    observeEvent(input$month_update_btn_reset,{
      shinyjs::enable('month_update_btn')
    })
    
    #处理自有资金日报-----
    var_own_year <- var_numeric('own_year')
    var_own_month <-var_numeric('own_month')
    var_own_unit <-var_ListChoose1('own_amount_unit')
    data_own <- eventReactive(input$own_preview,{
      FYear = as.integer(var_own_year())
      FMonth = as.integer(var_own_month())
      FUnit = var_own_unit()
      res <-
        try(jlrdspkg::own_deal(conn=conn,FYear =FYear,FMonth = FMonth,FUnit = FUnit,digit = 2 ))
      return(res)
      
    })
    
    observeEvent(input$own_preview,{
      print(data_own())
      run_dataTable2(id = 'own_dataShow',data = data_own())
      FYear = as.integer(var_own_year())
      FMonth = as.integer(var_own_month())
      filename = paste0('自有资金月份下载_',FYear,FMonth,'.xlsx')
      run_download_xlsx('own_dl',data = data_own(),filename = filename)
    })

    
  
})
