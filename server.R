

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
    print(user_info)
    
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
       # print(user_info()$Fpermissions)
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
    #V1.6----------
    #年-------
    var_week_year <- var_numeric('week_year')
    #处理开始周与结束周
    #var_startWeekNo <-
    #var_endWeekNo <-
    #周类型-----
    var_week_Ftype <- var_ListChoose1('week_Ftype')
    #默念是自然周------
    #数据范围
    var_week_dataRange <- var_ListChoose1('week_dataRange')
    #字段类型
    var_week_amtType <- var_ListChooseN('week_amtType')
    output$weekSelector_ph <- renderPrint({
      
      #print('test_bug 1.6--------')
      week_year <- var_week_year()
      #print(week_year)
    
      week_Ftype <- var_week_Ftype()
      #print(week_Ftype)
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
      print(week_amtUnit)
      
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
      print('bug2')
      shinyjs::disable('week_update_btn')
      week_year <- var_week_year_update()
      week_year <- as.integer(week_year)
      print(week_year)
      week_Ftype <- var_week_Ftype_update()
      print(week_Ftype)
      weekNo <- input$weekNo_update
      weekNo <- as.integer(weekNo)
      print(weekNo)
      # try({
      #   jlrdspkg::week_deal(conn=conn,year=week_year,weekNo = weekNo,type = week_Ftype)
      #   jlrdspkg::week_stat(conn=conn,year=week_year,weekNo = weekNo,type = week_Ftype)
      # })
      
      
        jlrdspkg::week_update(conn=conn,Fyear = week_year,FweekNo = weekNo,Ftype = week_Ftype)
      
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
    var_own_year <- var_numeric('bcs_year')
    var_own_month <-var_numeric('bcs_month')
    #var_own_unit <-var_ListChoose1('own_amount_unit')
    data_own <- eventReactive(input$bcs_preview,{
      FYear = as.integer(var_own_year())
      FMonth = as.integer(var_own_month())
      #FUnit = var_own_unit()
      res <-
        try(jlrdspkg::own_deal(conn = conn,FYear =FYear,FMonth = FMonth,digit = 2 ))
      return(res)
      
    })
    
    observeEvent(input$bcs_preview,{
      print(data_own())
      run_dataTable2(id = 'bcs_dataShow',data = data_own())
      FYear = as.integer(var_own_year())
      FMonth = as.integer(var_own_month())
      filename = paste0('自有资金月份下载_',FYear,FMonth,'.xlsx')
      run_download_xlsx('bcs_dl',data = data_own(),filename = filename)
    })
    
    
    
    # 2.0管报自动化---
    # 2.1成本中心划分及渠道费用分配表---------
    var_md_costCenter_FYear <- var_text("md_costCenter_FYear")
    var_md_costCenter_FPeriod <- var_text("md_costCenter_FPeriod")
    
    observeEvent(input$md_costCenter_preview,{
      
      FYear = as.integer(var_md_costCenter_FYear())
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      FPeriod = as.integer(var_md_costCenter_FPeriod())
      if ( is.na(FPeriod)){
        pop_notice('请输入月份')
      }
      
      if((!is.na(FYear)) & (!is.na(FPeriod))){
        data <- jlrdspkg::mrpt_md_ui_costCenter(conn = conn,FYear = FYear,FPeriod = FPeriod )
        ncount <- nrow(data)
        
        if (ncount >0){
          run_dataTable2(id = 'md_costCenter_dataShow',data = data)
          run_download_xlsx(id = 'md_costCenter_dl',data = data,filename = '成本中心划分及渠道费用分配表.xlsx')
        }else{
          pop_notice('没有查到数据，请检查参数！')
        }
        
      }
      

      
 
      
    })
    
    var_md_costCenter_file <- var_file('md_costCenter_file')
    
    observeEvent(input$md_costCenter_upload,{
      
      FYear = as.integer(var_md_costCenter_FYear())
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      FPeriod = as.integer(var_md_costCenter_FPeriod())
      if ( is.na(FPeriod)){
        pop_notice('请输入月份')
      }
      
      file_name = var_md_costCenter_file()
      if(is.null(file_name)){
        pop_notice('请选择文件')
      }
      
      if((!is.na(FYear)) & (!is.na(FPeriod))  & (!is.null(file_name))){
        
        jlrdspkg::mrpt_md_ui_costCenter_read(conn = conn,file_name = file_name,FYear = FYear,FPeriod = FPeriod)
        #
        pop_notice('上传成功')
        
      }
      
      
      
    })
    
    #同步上月成本中心至本月------
    observeEvent(input$md_costCenter_syncLastOne,{
      FYear = as.integer(var_md_costCenter_FYear())
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      FPeriod = as.integer(var_md_costCenter_FPeriod())
      if ( is.na(FPeriod)){
        pop_notice('请输入月份')
      }

      
      if((!is.na(FYear)) & (!is.na(FPeriod))  ){
        
        jlrdspkg::mrpt_md_ui_costCenter_syncLastOne(conn = conn,FYear = FYear,FPeriod = FPeriod)
        #
        pop_notice('上月成本中心同步至当前月份成功!')
        
      }
      
      
      
      
      
      
    })
    
    
    #定义品牌及事业部定义文件-----
    var_md_division_preview_file <- var_file('md_division_preview_file')
    
    observeEvent(input$md_division_upload,{
      file_name <- var_md_division_preview_file()
      if(is.null(file_name)){
        pop_notice('请选择一下品牌渠道事业部定义文件')
      }else{
        jlrdspkg::mrpt_md_ui_division_read(file_name = file_name,conn = conn) 
        pop_notice('上传成功')

      }
      
      
      
      
    })

    
    #2.2事业部定义--------
    observeEvent(input$md_division_preview,{
    
      data <- jlrdspkg::mrpt_md_ui_division(conn = conn)
      ncount <- nrow(data)
      print('divison')
      
      if (ncount >0){
        run_dataTable2(id = 'md_division_dataShow',data = data)
        run_download_xlsx(id = 'md_division_dl',data = data,filename = '事业部定义.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
      }
      
      
      
    })
    
    #2.3SAP数据源-------
    var_ds_sap_FYear <- var_text("ds_sap_FYear")
    var_ds_sap_FPeriod <- var_text("ds_sap_FPeriod")
    
    observeEvent(input$ds_sap_preview,{
      
      FYear = as.integer(var_ds_sap_FYear())
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      FPeriod = as.integer(var_ds_sap_FPeriod())
      if ( is.na(FPeriod)){
        pop_notice('请输入月份')
      }
      
      if((!is.na(FYear)) & (!is.na(FPeriod))){
        data <- jlrdspkg::mrpt_ds_ui_sapData(conn = conn,FYear = FYear,FPeriod = FPeriod )
        ncount <- nrow(data)
        
        if (ncount >0){
          run_dataTable2(id = 'ds_sap_dataShow',data = data)
          run_download_xlsx(id = 'ds_sap_dl',data = data,filename = 'SAP数据源.xlsx')
        }else{
          pop_notice('没有查到数据，请检查参数！')
        }
        
      }
      
      
      
      
      
    })
    
    #2.4成本项目及报表项目对照表------------
    
    var_itemMap_FYear <- var_text("itemMap_FYear")
    var_itemMap_FPeriod <- var_text("itemMap_FPeriod")
    
    observeEvent(input$itemMap_preview,{
      
      FYear = as.integer(var_itemMap_FYear())
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      FPeriod = as.integer(var_itemMap_FPeriod())
      if ( is.na(FPeriod)){
        pop_notice('请输入月份')
      }
      
      if((!is.na(FYear)) & (!is.na(FPeriod))){
        data <- jlrdspkg::mrpt_ui_itemMapping_costRpt(conn = conn,FYear = FYear,FPeriod = FPeriod )
        ncount <- nrow(data)
        
        if (ncount >0){
          run_dataTable2(id = 'itemMap_dataShow',data = data)
          run_download_xlsx(id = 'itemMap_dl',data = data,filename = '成本项目及报表项目对照表.xlsx')
        }else{
          pop_notice('没有查到数据，请检查参数！')
        }
        
      }
      
      
      
      
      
    })
    
    var_itemMap_file <- var_file('itemMap_file')
    #成本要素上传---
     observeEvent(input$itemMap_upload,{
       file_name = var_itemMap_file() 
       FYear = as.integer(var_itemMap_FYear())
       
       if(is.na(FYear)){
         pop_notice('请输入年份')
       }
       
       FPeriod = as.integer(var_itemMap_FPeriod())
       if ( is.na(FPeriod)){
         pop_notice('请输入月份')
       }
       
       if(is.null(file_name)){
         pop_notice('请选择一下文件')
       }
       
       if((!is.na(FYear)) & (!is.na(FPeriod)) & (!is.null(file_name))){
         
         jlrdspkg::mrpt_md_ui_costItem_read(conn = conn,file_name = file_name,FYear = FYear,FPeriod = FPeriod)
         pop_notice('上传成本要素成功！')

         
       }
       
       
       
       
       
       
     })
    
     
     #同步上月成本要素至当前月-----
     observeEvent(input$itemMap_syncLastOne,{
     
       FYear = as.integer(var_itemMap_FYear())
       
       if(is.na(FYear)){
         pop_notice('请输入年份')
       }
       
       FPeriod = as.integer(var_itemMap_FPeriod())
       if ( is.na(FPeriod)){
         pop_notice('请输入月份')
       }
       
   
       if((!is.na(FYear)) & (!is.na(FPeriod)) ){
         
         jlrdspkg::mrpt_md_ui_costItem_syncLastOne(conn = conn,FYear = FYear,FPeriod = FPeriod)
         pop_notice('同步成本要素成功！')
         
         
       }
       
       
       
       
       
       
     })
     
     
     
     
    
    
    #2.5报表项目----------
    
    observeEvent(input$md_rptItem_preview,{
      
      data <- jlrdspkg::mrpt_md_ui_rptItem(conn = conn)
      print(data)
      ncount <- nrow(data)
      print('div')
      
      if (ncount >0){
        run_dataTable2(id = 'md_rptItem_dataShow',data = data)
        run_download_xlsx(id = 'md_rptItem_dl',data = data,filename = '报表项目.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
      }
      
      
      
    })
     
     var_md_rptItem_file <- var_file('md_rptItem_file')
     observeEvent(input$md_rptItem_upload,{
       file_name =  var_md_rptItem_file()
       if(is.null(file_name)){
         '请选择一下上传文件'
       }else{
         jlrdspkg::mrpt_md_ui_rptItem_read(conn = conn,file_name = file_name)
         pop_notice('上传服务项目成功')

       }
       
       
     })
    
    #2.6 BW指标固定表头--------
    observeEvent(input$md_bw_Heading_preview,{
      
      data <- jlrdspkg::mrpt_bw_ui_getHeadingName(conn = conn)
      print(data)
      ncount <- nrow(data)
      print('div')
      
      if (ncount >0){
        run_dataTable2(id = 'md_bw_Heading_dataShow',data = data)
        run_download_xlsx(id = 'md_bw_Heading_dl',data = data,filename = 'BW固定表头.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
      }
      
      
      
    })
    #2.7 BW维度变动表头--------
    observeEvent(input$md_bw_dim_preview,{
      
      data <- jlrdspkg::mrpt_bw_ui_getDimName(conn = conn)
      print(data)
      ncount <- nrow(data)
      print('div')
      
      if (ncount >0){
        run_dataTable2(id = 'md_bw_dim_dataShow',data = data)
        run_download_xlsx(id = 'md_bw_dim_dl',data = data,filename = 'BW维度变动表头.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
      }
      
      
      
    })
     #上传BW报表维度
     var_md_bw_dim_file <- var_file('md_bw_dim_file')
      observeEvent(input$md_bw_dim_upload,{
        
        file_name <- var_md_bw_dim_file()
        if(is.null(file_name)){
          pop_notice('请选择上传文件')
        }else{
          jlrdspkg::mrpt_bw_ui_getDimName_read(conn = conn,file_name = file_name)
          pop_notice('上传BW报表维度成功！')
        }
        
        
      })
    
    #2.8 BW报表业务规则----
      var_md_bwRule_FYear <- var_text('md_bwRule_FYear')
      var_md_bwRule_FPeriod <- var_text('md_bwRule_FPeriod')
    observeEvent(input$md_bw_businessRule_preview,{
      FYear = as.integer(var_md_bwRule_FYear())
      FPeriod = as.integer(var_md_bwRule_FPeriod())
      
      #data <- jlrdspkg::mrpt_bw_ui_businessRule(conn = conn)
      #第一版做了升级
      data <- jlrdspkg::mrpt_md_rule_bw2_select(conn = conn,FYear = FYear,FPeriod = FPeriod)
      # print(data)
      ncount <- nrow(data)
      #print('div')
      
      if (ncount >0){
        run_dataTable2(id = 'md_bw_businessRule_dataShow',data = data)
        run_download_xlsx(id = 'md_bw_businessRule_dl',data = data,filename = 'BW报表业务规则.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
      }
      
      
      
    })
      
      #上传BW报表业务规则----
      var_md_bw_businessRule_file <- var_file('md_bw_businessRule_file')
      observeEvent(input$md_bw_businessRule_upload,{
        FYear = as.integer(var_md_bwRule_FYear())
        FPeriod = as.integer(var_md_bwRule_FPeriod())
        file_name = var_md_bw_businessRule_file()
        if(is.null(file_name)){
          pop_notice('请选择一个文件')
        }else{
          jlrdspkg::mrpt_md_rule_bw2_read(conn = conn,file_name = file_name,FYear = FYear,FPeriod = FPeriod)
          pop_notice('上传BW报表业务规则成功')
        }
        
        
      })
      
      #同步上月BW规则至当前月---
      observeEvent(input$md_sync_bw_rule_fromLastOne,{
        
        FYear = as.integer(var_md_bwRule_FYear())
        FPeriod = as.integer(var_md_bwRule_FPeriod())
       
 
          jlrdspkg::mrpt_md_rule_bw2_syncLastOne(conn = conn,FYear = FYear,FPeriod = FPeriod)
          pop_notice('同步BW报表业务规则成功')
     
        
        
        
        
        
      })
      
      
    #重分类--------
      observeEvent(input$md_reClassifyAcct_mapping_query,{
        data <-jlrdspkg::mrpt_md_reClassify_select(conn = conn)
        run_dataTable2('md_reClassifyAcct_mapping_dataShow',data = data)
        run_download_xlsx(id = 'md_reClassifyAcct_mapping_dl',data = data,filename = '重分类及科目对照表.xlsx')
        
      })
      
      var_md_reClassifyAcct_mapping_file <- var_file('md_reClassifyAcct_mapping_file')
      observeEvent(input$md_reClassifyAcct_mapping_upload,{
        file_name <- var_md_reClassifyAcct_mapping_file()
        
        if(is.null(file_name)){
          pop_notice('请选择一下重分类对照表文件！')
        }else{
          jlrdspkg::mrpt_md_reClassify_read(conn = conn,file_name = file_name)
          pop_notice('上传成功！')
        }
        
        
        
      })
    
    #2.9 bw数据源------
    var_ds_bw_FYear <- var_text("ds_bw_FYear")
    var_ds_bw_FPeriod <- var_text("ds_bw_FPeriod")
    
    observeEvent(input$ds_bw_preview,{
      
      FYear = as.integer(var_ds_bw_FYear())
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      FPeriod = as.integer(var_ds_bw_FPeriod())
      if ( is.na(FPeriod)){
        pop_notice('请输入月份')
      }
      
      if((!is.na(FYear)) & (!is.na(FPeriod))){
        data <- jlrdspkg::mrpt_bw_ds_data(conn = conn,FYear = FYear,FPeriod = FPeriod )
        ncount <- nrow(data)
        
        if (ncount >0){
          run_dataTable2(id = 'ds_bw_dataShow',data = data)
          run_download_xlsx(id = 'ds_bw_dl',data = data,filename = 'BW数据源.xlsx')
        }else{
          pop_notice('没有查到数据，请检查参数！')
        }
        
      }
      
      
      
      
      
    })
    
    #2.10客户折扣清单-------
    var_discount_FBrand <- var_text("md_discount_FBrand")

    observeEvent(input$md_discount_preview,{
      
      FBrand = as.character(var_discount_FBrand())
      
      if(is.na(FBrand)){
        pop_notice('请输入品牌')
      }
      
  
      
      if(!is.na(FBrand)){
        data <- jlrdspkg::mrpt_rule_discount(conn = conn,FBrand = FBrand )
        ncount <- nrow(data)
        
        if (ncount >0){
          run_dataTable2(id = 'md_discount_dataShow',data = data)
          run_download_xlsx(id = 'md_discount_dl',data = data,filename = '管报客户折扣清单.xlsx')
        }else{
          pop_notice('没有查到数据，请检查参数！')
        }
        
      }
      
      
      
      
      
    })
    
    #2.11历史数据------
    var_actual_FBrand <- var_text('actual_FBrand')
    var_actual_FChannel <- var_text('actual_FChannel')
    var_actual_FYear <- var_text('actual_FYear')
    var_actual_FPeriod <- var_text('actual_FPeriod')
    
    
    observeEvent(input$actual_preview,{
      
      FBrand = as.character(var_actual_FBrand()) 
      FChannel = as.character(var_actual_FChannel()) 
      FYear =  as.integer(var_actual_FYear()) 
      FPeriod = as.integer(var_actual_FPeriod()) 
      if(is.na(FBrand)){
        pop_notice('请输入品牌')
      }
      
      if(is.na(FChannel)){
        pop_notice('请输入渠道')
      }
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      if(is.na(FPeriod)){
        pop_notice('请输入期间')
      }
      
      data <- jlrdspkg::mrpt_actualData_read(conn=conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel)
      
      ncount <- nrow(data)
      
      if (ncount >0){
        run_dataTable2(id = 'actual_dataShow',data = data)
        run_download_xlsx(id = 'actual_dl',data = data,filename = '历史数据.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
      }
      
      
      
    })
    
    #2.12手工调整数据源------
    
    var_adj_FYear <- var_text("adj_FYear")
    var_adj_FPeriod <- var_text("adj_FPeriod")
    
    observeEvent(input$adj_preview,{
      
      FYear = as.integer(var_adj_FYear())
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      FPeriod = as.integer(var_adj_FPeriod())
      if ( is.na(FPeriod)){
        pop_notice('请输入月份')
      }
      
      if((!is.na(FYear)) & (!is.na(FPeriod))){
        data <- jlrdspkg::mrpt_adj_readData_ui(conn = conn,FYear = FYear,FPeriod = FPeriod )
        ncount <- nrow(data)
        
        if (ncount >0){
          run_dataTable2(id = 'adj_dataShow',data = data)
          run_download_xlsx(id = 'adj_dl',data = data,filename = '手工调整数据下载.xlsx')
        }else{
          pop_notice('没有查到数据，请检查参数！')
        }
        
      }
      
      
      
      
      
    })
    
    #2.13执行预算数据----
    var_budget_FBrand <- var_text('budget_FBrand')
    var_budget_FChannel <- var_text('budget_FChannel')
    var_budget_FYear <- var_text('budget_FYear')
    var_budget_FPeriod <- var_text('budget_FPeriod')
    
    
    observeEvent(input$budget_preview,{
      
      FBrand = as.character(var_budget_FBrand()) 
      FChannel = as.character(var_budget_FChannel()) 
      FYear =  as.integer(var_budget_FYear()) 
      FPeriod = as.integer(var_budget_FPeriod()) 
      if(is.na(FBrand)){
        pop_notice('请输入品牌')
      }
      
      if(is.na(FChannel)){
        pop_notice('请输入渠道')
      }
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      if(is.na(FPeriod)){
        pop_notice('请输入期间')
      }
      
      data <- jlrdspkg::mrpt_budget_readFromDB_ByBrandChannel(conn=conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel)
      
      ncount <- nrow(data)
      
      if (ncount >0){
        run_dataTable2(id = 'budget_dataShow',data = data)
        run_download_xlsx(id = 'budget_dl',data = data,filename = '执行预算.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
      }
      
      
      
    })
    
    
    
    #历史数据,品牌渠道------
    var_actual_FChannel_upload1 <- var_ListChooseN('actual_FChannel_upload1')
    var_actual_FYear_upload1 <- var_text('actual_FYear_upload1')
    var_actual_FPeriod_upload1 <- var_text('actual_FPeriod_upload1')
    var_actual_upload_type1 <- var_ListChoose1('actual_upload_type1')
    var_actual_upload_file1 <- var_file('actual_upload_file1')
    observeEvent(input$actual_upload_done1,{
      FBrand <- input$actual_FBrand_upload1
      FChannels <- var_actual_FChannel_upload1()
      FYear <- as.integer(var_actual_FYear_upload1())
      FPeriod <-as.integer(var_actual_FPeriod_upload1())
      FType = var_actual_upload_type1()
      file_name <- var_actual_upload_file1()
      
      print(FBrand)
      print(FChannels)
      print(FYear)
      print(FPeriod)
      print(FType)
      print(file_name)
      
      ncount = length(FChannels)
      if (ncount >0){
        lapply(FChannels,function(FChannel){
          
          if(FType){
            #当月数据
            try(jlrdspkg::mrpt_actual_readData_ByDivision_currentPeriod(conn = conn,file = file_name,sheet = FChannel,FBrand = FBrand,FChannel = FChannel,FYear = FYear,FPeriod = FPeriod))
          }else{
            try(jlrdspkg::mrpt_actual_readData_ByDivision_cumPeriod(conn = conn,file = file_name,sheet = FChannel,FBrand = FBrand,FChannel = FChannel,FYear = FYear,FPeriod = FPeriod))
          }
          
          
        })
        pop_notice(paste0(FBrand,FChannels,'上传服务器成功'))
      }
      
      
      
      
      
      
    })
    
    
    
    
    
    
    
    #执行预算,品牌渠道----
    var_budget_FChannel_upload <- var_ListChooseN('budget_FChannel_upload')
    varbudget_FYear_upload <- var_text('budget_FYear_upload')
    varbudget_FPeriod_upload <- var_text('budget_FPeriod_upload')
    var_budget_upload_type <- var_ListChoose1('budget_upload_type')
    var_budget_upload_file <- var_file('budget_upload_file')
    observeEvent(input$budget_upload_done,{
      FBrand <- input$budget_FBrand_upload
      FChannels <- var_budget_FChannel_upload()
      FYear <- as.integer(varbudget_FYear_upload())
      FPeriod <-as.integer(varbudget_FPeriod_upload())
      FType = var_budget_upload_type()
      file_name <- var_budget_upload_file()
      
      print(FBrand)
      print(FChannels)
      print(FYear)
      print(FPeriod)
      print(FType)
      print(file_name)
      
      ncount = length(FChannels)
      if (ncount >0){
        lapply(FChannels,function(FChannel){
          
          if(FType){
            #当月数据
            try(jlrdspkg::mrpt_budget_readData_ByDivision_currentPeriod(conn = conn,file = file_name,sheet = FChannel,FBrand = FBrand,FChannel = FChannel,FYear = FYear,FPeriod = FPeriod))
          }else{
            try(jlrdspkg::mrpt_budget_readData_ByDivision_cumPeriod(conn = conn,file = file_name,sheet = FChannel,FBrand = FBrand,FChannel = FChannel,FYear = FYear,FPeriod = FPeriod))
          }
          
          
        })
        pop_notice(paste0(FBrand,FChannels,'上传服务器成功'))
      }
      
      
      
      
      
      
    })
    
    #历史数据,子渠道----
    
    var_actual_FYear_upload_sub2 <- var_text('actual_FYear_upload_sub2')
    var_actual_FPeriod_upload_sub2 <- var_text('actual_FPeriod_upload_sub2')
    var_actual_upload_type_sub2 <- var_ListChoose1('actual_upload_type_sub2')
    var_actual_upload_file_sub2 <- var_file('actual_upload_file_sub2')
    var_actual_FChannel_upload_sub2 <- var_ListChooseN('actual_FChannel_upload_sub2')
    observeEvent(input$actual_upload_done_sub2,{
      FBrand <- input$actual_FBrand_upload_sub2
      FChannel <- input$actual_FChannel_upload_sub2
      FSubChannels <-   var_actual_FChannel_upload_sub2()
      FYear <- as.integer(var_actual_FYear_upload_sub2())
      FPeriod <-as.integer( var_actual_FPeriod_upload_sub2())
      FType = var_actual_upload_type_sub2()
      file_name <-  var_actual_upload_file_sub2()
      
      print(FBrand)
      print(FChannel)
      print(FSubChannels)
      print(FYear)
      print(FPeriod)
      print(FType)
      print(file_name)
      
      ncount = length(FSubChannels)
      if (ncount >0){
        lapply(FSubChannels,function(FSubChannel){
          
          if(FType){
            #当月数据
            try(jlrdspkg::mrpt_actual_readData_ByDivision_currentPeriod(conn = conn,file = file_name,sheet = FSubChannel,FBrand = FBrand,FChannel = FChannel,FYear = FYear,FPeriod = FPeriod,FSubChannel = FSubChannel))
          }else{
            try(jlrdspkg::mrpt_actual_readData_ByDivision_cumPeriod(conn = conn,file = file_name,sheet = FSubChannel,FBrand = FBrand,FChannel = FChannel,FYear = FYear,FPeriod = FPeriod,FSubChannel = FSubChannel))
          }
          
          
        })
        pop_notice(paste0(FBrand,FChannel,FSubChannels,'上传服务器成功'))
      }
      
      
      
      
      
      
    })
    
    
    
    #执行预算,子渠道----
    
    varbudget_FYear_upload_sub <- var_text('budget_FYear_upload_sub')
    varbudget_FPeriod_upload_sub <- var_text('budget_FPeriod_upload_sub')
    var_budget_upload_type_sub <- var_ListChoose1('budget_upload_type_sub')
    var_budget_upload_file_sub <- var_file('budget_upload_file_sub')
    var_budget_FChannel_upload_sub2 <- var_ListChooseN('budget_FChannel_upload_sub2')
    observeEvent(input$budget_upload_done_sub,{
      FBrand <- input$budget_FBrand_upload_sub
      FChannel <- input$budget_FChannel_upload_sub
      FSubChannels <-  var_budget_FChannel_upload_sub2()
      FYear <- as.integer(varbudget_FYear_upload_sub())
      FPeriod <-as.integer( varbudget_FPeriod_upload_sub())
      FType = var_budget_upload_type_sub()
      file_name <- var_budget_upload_file_sub()
      
      print(FBrand)
      print(FChannel)
      print(FSubChannels)
      print(FYear)
      print(FPeriod)
      print(FType)
      print(file_name)
      
      ncount = length(FSubChannels)
      if (ncount >0){
        lapply(FSubChannels,function(FSubChannel){
          
          if(FType){
            #当月数据
            try(jlrdspkg::mrpt_budget_readData_ByDivision_currentPeriod(conn = conn,file = file_name,sheet = FSubChannel,FBrand = FBrand,FChannel = FChannel,FYear = FYear,FPeriod = FPeriod,FSubChannel = FSubChannel))
          }else{
            try(jlrdspkg::mrpt_budget_readData_ByDivision_cumPeriod(conn = conn,file = file_name,sheet = FSubChannel,FBrand = FBrand,FChannel = FChannel,FYear = FYear,FPeriod = FPeriod,FSubChannel = FSubChannel))
          }
          
          
        })
        pop_notice(paste0(FBrand,FChannel,FSubChannels,'上传服务器成功'))
      }
      
      
      
      
      
      
    })
    
    #2.14 SAP处理中间表-----
    var_sap_deal_FBrand <- var_text('sap_deal_FBrand')
    var_sap_deal_FChannel <- var_text('sap_deal_FChannel')
    var_sap_deal_FYear <- var_text('sap_deal_FYear')
    var_sap_deal_FPeriod <- var_text('sap_deal_FPeriod')
    
    
    observeEvent(input$sap_deal_preview,{
      
      FBrand = as.character(var_sap_deal_FBrand()) 
      FChannel = as.character(var_sap_deal_FChannel()) 
      FYear =  as.integer(var_sap_deal_FYear()) 
      FPeriod = as.integer(var_sap_deal_FPeriod()) 
      if(is.na(FBrand)){
        pop_notice('请输入品牌')
      }
      
      if(is.na(FChannel)){
        pop_notice('请输入渠道')
      }
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      if(is.na(FPeriod)){
        pop_notice('请输入期间')
      }
      
      data <- jlrdspkg::sap_res_ui_fromDB(conn=conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel)
      
      ncount <- nrow(data)
      
      if (ncount >0){
        run_dataTable2(id = 'sap_deal_dataShow',data = data)
        run_download_xlsx(id = 'sap_deal_dl',data = data,filename = 'SAP处理中间表.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
      }
      
      
      
    })
    
    #2.15BW处理中间表
    var_bw_deal_FBrand <- var_text('bw_deal_FBrand')
    var_bw_deal_FChannel <- var_text('bw_deal_FChannel')
    var_bw_deal_FYear <- var_text('bw_deal_FYear')
    var_bw_deal_FPeriod <- var_text('bw_deal_FPeriod')
    
    
    observeEvent(input$bw_deal_preview,{
      
      FBrand = as.character(var_bw_deal_FBrand()) 
      print(FBrand)
      FChannel = as.character(var_bw_deal_FChannel()) 
      print(FChannel)
      FYear =  as.integer(var_bw_deal_FYear()) 
      print(FYear)
      FPeriod = as.integer(var_bw_deal_FPeriod()) 
      print(FPeriod)
      if(is.na(FBrand)){
        pop_notice('请输入品牌')
      }
      
      if(is.na(FChannel)){
        pop_notice('请输入渠道')
      }
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      if(is.na(FPeriod)){
        pop_notice('请输入期间')
      }
      
      data <- jlrdspkg::bw_res_ui_fromDB(conn=conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel)
      print(data)
      
      ncount <- nrow(data)
      
      if (ncount >0){
        run_dataTable2(id = 'bw_deal_dataShow',data = data)
        run_download_xlsx(id = 'bw_deal_dl',data = data,filename = 'BW处理中间表.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
      }
      
      
      
    })
    #2.16手调处理表222------
    
    
    var_adj_deal_FBrand <- var_text('adj_deal_FBrand')
    var_adj_deal_FChannel <- var_text('adj_deal_FChannel')
    var_adj_deal_FYear <- var_text('adj_deal_FYear')
    var_adj_deal_FPeriod <- var_text('adj_deal_FPeriod')
    
    
    observeEvent(input$adj_deal_preview,{
      
      FBrand = as.character(var_adj_deal_FBrand()) 
      FChannel = as.character(var_adj_deal_FChannel()) 
      FYear =  as.integer(var_adj_deal_FYear()) 
      FPeriod = as.integer(var_adj_deal_FPeriod()) 
      if(is.na(FBrand)){
        pop_notice('请输入品牌')
      }
      
      if(is.na(FChannel)){
        pop_notice('请输入渠道')
      }
      
      if(is.na(FYear)){
        pop_notice('请输入年份')
      }
      
      if(is.na(FPeriod)){
        pop_notice('请输入期间')
      }
      
      data <- jlrdspkg::adj_res_ui_fromDB(conn=conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel)
      
      ncount <- nrow(data)
      
      if (ncount >0){
        run_dataTable2(id = 'adj_deal_dataShow',data = data)
        run_download_xlsx(id = 'adj_deal_dl',data = data,filename = '手工调整处理中间表.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
      }
      
      
      
    })
    
    
    
    #自然堂科目对照表-----
    
    var_md_chando_eCom_acctRpt_mapping_file <- var_file('md_chando_eCom_acctRpt_mapping_file')
    observeEvent(input$md_chando_eCom_acctRpt_mapping_upload,{
      file_name <- var_md_chando_eCom_acctRpt_mapping_file()
      if(is.null(file_name)){
        pop_notice('请先选择一个对照表文件')
      }else{
        data <- jlrdspkg::mrpt_md_chando_acctRpt_read(conn = conn,file_name = file_name)
        pop_notice('上传成功')
      }
   
      
    })
    observeEvent(input$md_chando_eCom_acctRpt_mapping_query,{
      data <- jlrdspkg::mrpt_md_chando_acctRpt_select(conn = conn)
      run_dataTable2('md_chando_eCom_acctRpt_mapping_dataShow',data = data)
      #下载对照表
      run_download_xlsx(id = 'md_chando_eCom_acctRpt_mapping_dl',data = data,filename = '自然堂电商科目与报表项目对照表.xlsx')
    })
    
  #4.报表分析-----
    # display the data that is available to be drilled down
    #下面数据
    data_division_summary <- jlrdspkg::mrpt_analysis_md_division_summary(conn = conn)

    
    output$mrpt_analysis_md_division_summary <- DT::renderDataTable(data_division_summary,selection = 'single')
    
    # subset the records to the row that was clicked
    drilldata <- reactive({
      shiny::validate(
        need(length(input$mrpt_analysis_md_division_summary_rows_selected) > 0, "请选中任意一行")
      )    
      
      # subset the summary table and extract the column to subset on
      # if you have more than one column, consider a merge instead
      # NOTE: the selected row indices will be character type so they
      #   must be converted to numeric or integer before subsetting
      selected_row <- data_division_summary[as.integer(input$mrpt_analysis_md_division_summary_rows_selected), '财务伙伴']
      data_detail <- jlrdspkg::mrpt_analysis_md_division_detail(conn = conn,FFinancialPartner =selected_row )
      return(data_detail)

    })
    
    # display the subsetted data
    output$mrpt_analysis_md_division_drilldown <- DT::renderDataTable(drilldata())
    
    var_res_review_brandChannel_man <- var_ListChoose1('res_review_brandChannel_man')
    var_res_review_brandChannel_Year <- var_text('res_review_brandChannel_Year')
    var_res_review_brandChannel_period <- var_text('res_review_brandChannel_period')
    observeEvent(input$res_review_brandChannel_btn,{
      FFinancialMan <- var_res_review_brandChannel_man()
      FYear <-as.integer(var_res_review_brandChannel_Year())
      FPeriod <- as.integer(var_res_review_brandChannel_period())
      print(FFinancialMan)
      print(FYear)
      print(FPeriod)
      data <- jlrdspkg::mrpt_res_review_brandChannel(FFinancialPartner = FFinancialMan,FYear = FYear,FPeriod = FPeriod)
      run_dataTable2('res_review_brandChannel_dataShow',data = data)
      run_download_xlsx('res_review_brandChannel_dl',data = data,filename = '管报对照表.xlsx')
      
    })
    #凭证分析-重分类前凭证-----
    var_voucher_audit_beforeReclass_Year <- var_text('voucher_audit_beforeReclass_Year')
    var_voucher_audit_beforeReclass_Period <- var_integer('voucher_audit_beforeReclass_Period')
    
    
    data_voucher_before_summary <- eventReactive(input$voucher_audit_beforeReclass_btn,{
      FYear =  as.integer(var_voucher_audit_beforeReclass_Year())
      FPeriod =  as.integer( var_voucher_audit_beforeReclass_Period())
      data_summary <- mrptpkg::voucher_beforeReClass_costItem_summary(conn = conn,FYear = FYear,FPeriod = FPeriod)
      names(data_summary) <-c('成本要素代码','成本要素名称','总金额','记录数')
      return(data_summary)
      
    })
    
    
    observeEvent(input$voucher_audit_beforeReclass_btn,{
      
      output$voucher_beforeReClass_summary_dt <- DT::renderDataTable(data_voucher_before_summary(),selection = 'single')
      
    })
    
   
    
    
    drilldata1 <- reactive({
      FYear =  as.integer(var_voucher_audit_beforeReclass_Year())
      FPeriod =  as.integer( var_voucher_audit_beforeReclass_Period())
      shiny::validate(
        need(length(input$voucher_beforeReClass_summary_dt_rows_selected) > 0, "请选中任意一行")
      )    
      data_summary <- data_voucher_before_summary()
      FCostItemNumber <- data_summary[as.integer(input$voucher_beforeReClass_summary_dt_rows_selected), '成本要素代码']
      data_detail1 <- mrptpkg::voucher_beforeReClass_costItem_detail_costCenterNo(conn = conn,FYear = FYear,FPeriod = FPeriod,FCostItemNumber = FCostItemNumber)
      names(data_detail1) <- c('成本要素代码','成本中心代码','成本中心名称','总金额','记录数')
      return(data_detail1)
      
    })
    
    output$voucher_beforeReClass_detail_dt1 <- DT::renderDataTable(drilldata1(),selection = 'single')
    
    drilldata2 <- reactive({
      FYear =  as.integer(var_voucher_audit_beforeReclass_Year())
      FPeriod =  as.integer( var_voucher_audit_beforeReclass_Period())
      shiny::validate(
        need(length(input$voucher_beforeReClass_detail_dt1_rows_selected) > 0, "请选中任意一行")
      )    
      #data1 = drilldata1()
      FCostItemNumber <- drilldata1()[as.integer(input$voucher_beforeReClass_detail_dt1_rows_selected), '成本要素代码']
      #print(FCostItemNumber)
      FCostCenterNo <- drilldata1()[as.integer(input$voucher_beforeReClass_detail_dt1_rows_selected), '成本中心代码']
      #print(FCostCenterNo)
      data_detail2 <- mrptpkg::voucher_beforeReClass_costItem_detail_list(conn = conn,FYear = FYear,FPeriod = FPeriod,FCostItemNumber = FCostItemNumber,FCostCenterNo = FCostCenterNo)
      names(data_detail2) <- c('凭证日期','过账日期','成本中心代码','成本中心名称','成本要素代码','成本要素名称','凭证金额','凭证摘要','重分类代码','凭证号')
      return(data_detail2)
      
    })
    
    #print(drilldata2())
    
    output$voucher_beforeReClass_detail_dt2 <- DT::renderDataTable(drilldata2(),selection = 'single')
    
    
    #凭证分析重分类后-----
    var_voucher_audit_afterReclass_Year <- var_text('voucher_audit_afterReclass_Year')
    var_voucher_audit_afterReclass_Period <- var_integer('voucher_audit_afterReclass_Period')
    
    
    data_voucher_after_summary <- eventReactive(input$voucher_audit_afterReclass_btn,{
      FYear =  as.integer(var_voucher_audit_afterReclass_Year())
      FPeriod =  as.integer( var_voucher_audit_afterReclass_Period())
      data_summary <- mrptpkg::voucher_afterReClass_costItem_summary(conn = conn,FYear = FYear,FPeriod = FPeriod)
      names(data_summary) <-c('成本要素代码','成本要素名称','总金额','记录数')
      return(data_summary)
      
    })
    
    
    observeEvent(input$voucher_audit_afterReclass_btn,{
      
      output$voucher_afterReClass_summary_dt <- DT::renderDataTable(data_voucher_after_summary(),selection = 'single')
      
    })
    
    
    
    
    drilldata1_after <- reactive({
      FYear =  as.integer(var_voucher_audit_afterReclass_Year())
      FPeriod =  as.integer( var_voucher_audit_afterReclass_Period())
      shiny::validate(
        need(length(input$voucher_afterReClass_summary_dt_rows_selected) > 0, "请选中任意一行")
      )    
      data_summary <- data_voucher_after_summary()
      FCostItemNumber <- data_summary[as.integer(input$voucher_afterReClass_summary_dt_rows_selected), '成本要素代码']
      data_detail1 <- mrptpkg::voucher_afterReClass_costItem_detail_costCenterNo(conn = conn,FYear = FYear,FPeriod = FPeriod,FCostItemNumber = FCostItemNumber)
      names(data_detail1) <- c('成本要素代码','成本中心代码','成本中心名称','总金额','记录数')
      return(data_detail1)
      
    })
    
    output$voucher_afterReClass_detail_dt1 <- DT::renderDataTable(drilldata1_after(),selection = 'single')
    
    drilldata2_after <- reactive({
      FYear =  as.integer(var_voucher_audit_afterReclass_Year())
      FPeriod =  as.integer( var_voucher_audit_afterReclass_Period())
      shiny::validate(
        need(length(input$voucher_afterReClass_detail_dt1_rows_selected) > 0, "请选中任意一行")
      )    
      #data1 = drilldata1()
      FCostItemNumber <- drilldata1_after()[as.integer(input$voucher_afterReClass_detail_dt1_rows_selected), '成本要素代码']
      #print(FCostItemNumber)
      FCostCenterNo <- drilldata1_after()[as.integer(input$voucher_afterReClass_detail_dt1_rows_selected), '成本中心代码']
      #print(FCostCenterNo)
      data_detail2 <- mrptpkg::voucher_afterReClass_costItem_detail_list(conn = conn,FYear = FYear,FPeriod = FPeriod,FCostItemNumber = FCostItemNumber,FCostCenterNo = FCostCenterNo)
      names(data_detail2) <- c('凭证日期','过账日期','成本中心代码','成本中心名称','成本要素代码1','成本要素名称1','凭证金额','凭证摘要','重分类代码','凭证号','成本要素代码2','成本要素名称2','成本要素代码','成本要素名称')
      return(data_detail2)
      
    })
    
    #print(drilldata2())
    
    output$voucher_afterReClass_detail_dt2 <- DT::renderDataTable(drilldata2_after(),selection = 'single')
    
    
    
    #凭证分析-仅重分类凭证-----
    var_voucher_audit_onlyReclass_Year <- var_text('voucher_audit_onlyReclass_Year')
    var_voucher_audit_onlyReclass_Period <- var_integer('voucher_audit_onlyReclass_Period')
    
    
    data_voucher_only_summary <- eventReactive(input$voucher_audit_onlyReclass_btn,{
      FYear =  as.integer(var_voucher_audit_onlyReclass_Year())
      FPeriod =  as.integer( var_voucher_audit_onlyReclass_Period())
      data_summary <- mrptpkg::voucher_onlyReClass_costItem_summary(conn = conn,FYear = FYear,FPeriod = FPeriod)
      names(data_summary) <-c('重分类代码','成本要素代码','成本要素名称','总金额','记录数')
      return(data_summary)
      
    })
    
    
    observeEvent(input$voucher_audit_onlyReclass_btn,{
      
      output$voucher_onlyReClass_summary_dt <- DT::renderDataTable(data_voucher_only_summary(),selection = 'single')
      
    })
    
    
    
    
    drilldata1_only <- reactive({
      FYear =  as.integer(var_voucher_audit_onlyReclass_Year())
      FPeriod =  as.integer( var_voucher_audit_onlyReclass_Period())
      shiny::validate(
        need(length(input$voucher_onlyReClass_summary_dt_rows_selected) > 0, "请选中任意一行")
      )    
      data_summary <- data_voucher_only_summary()
      FReClassifiedNumber  <- data_summary[as.integer(input$voucher_onlyReClass_summary_dt_rows_selected), '重分类代码']
      data_detail1 <- mrptpkg::voucher_onlyReClass_costItem_detail_costCenterNo(conn = conn,FYear = FYear,FPeriod = FPeriod,FReClassifiedNumber = FReClassifiedNumber)
      names(data_detail1) <- c('重分类代码','成本要素代码','成本中心代码','成本中心名称','总金额','记录数')
      return(data_detail1)
      
    })
    
    output$voucher_onlyReClass_detail_dt1 <- DT::renderDataTable(drilldata1_only(),selection = 'single')
    
    drilldata2_only <- reactive({
      FYear =  as.integer(var_voucher_audit_onlyReclass_Year())
      FPeriod =  as.integer( var_voucher_audit_onlyReclass_Period())
      shiny::validate(
        need(length(input$voucher_onlyReClass_detail_dt1_rows_selected) > 0, "请选中任意一行")
      )    
      #data1 = drilldata1()
      FReClassifiedNumber <- drilldata1_only()[as.integer(input$voucher_onlyReClass_detail_dt1_rows_selected), '重分类代码']
      #print(FCostItemNumber)
      FCostCenterNo <- drilldata1_only()[as.integer(input$voucher_onlyReClass_detail_dt1_rows_selected), '成本中心代码']
      #print(FCostCenterNo)
      data_detail2 <- mrptpkg::voucher_onlyReClass_costItem_detail_list(conn = conn,FYear = FYear,FPeriod = FPeriod,FReClassifiedNumber = FReClassifiedNumber,FCostCenterNo = FCostCenterNo)
      names(data_detail2) <- c('凭证日期','过账日期','成本中心代码','成本中心名称','成本要素代码1','成本要素名称1','凭证金额','凭证摘要','重分类代码','凭证号','成本要素代码2','成本要素名称2','成本要素代码','成本要素名称')
      return(data_detail2)
      
    })
    
    #print(drilldata2())
    
    output$voucher_onlyReClass_detail_dt2 <- DT::renderDataTable(drilldata2_only(),selection = 'single')
    
    #成本要素分析-------

    var_mrpt_audit_md_costItem_Year <- var_text('mrpt_audit_md_costItem_Year')
    var_mrpt_audit_md_costItem_Period <- var_integer('mrpt_audit_md_costItem_Period')
    
    
    data_costItem_summary <- eventReactive(input$mrpt_audit_md_costItem_btn,{
      FYear =  as.integer(var_mrpt_audit_md_costItem_Year())
      FPeriod =  as.integer( var_mrpt_audit_md_costItem_Period())
      data_summary <- mrptpkg::md_costItem_audit_summary(conn = conn,FYear = FYear,FPeriod = FPeriod)
      names(data_summary) <-c('统一费用名称','记录数')
      return(data_summary)
      
    })
    
    
    observeEvent(input$mrpt_audit_md_costItem_btn,{
      
      output$mrpt_audit_md_costItem_summary <- DT::renderDataTable(data_costItem_summary(),selection = 'single')
      
    })
    
    
    
    
    drilldata1_costItem <- reactive({
      FYear =  as.integer(var_mrpt_audit_md_costItem_Year())
      FPeriod =  as.integer( var_mrpt_audit_md_costItem_Period())
      shiny::validate(
        need(length(input$mrpt_audit_md_costItem_summary_rows_selected) > 0, "请选中任意一行")
      )    
      data_summary <- data_costItem_summary()
      FFeeName  <- data_summary[as.integer(input$mrpt_audit_md_costItem_summary_rows_selected), '统一费用名称']
      data_detail1 <- mrptpkg::md_costItem_audit_detail(conn = conn,FYear = FYear,FPeriod = FPeriod,FFeeName = FFeeName)
      names(data_detail1) <- c('统一费用名称(规范)','成本要素代码','成本要素名称','统一费用名称(待核)')
      return(data_detail1)
      
    })
    
    output$mrpt_audit_md_costItem_detail <- DT::renderDataTable(drilldata1_costItem(),selection = 'single')
    
    #成本中心分析------
    
    var_mrpt_audit_md_costCenter_Year <- var_text('mrpt_audit_md_costCenter_Year')
    var_mrpt_audit_md_costCenter_Period <- var_integer('mrpt_audit_md_costCenter_Period')
    
    
    data_md_costCenter_summary <- eventReactive(input$mrpt_audit_md_costCenter_btn,{
      FYear =  as.integer(var_mrpt_audit_md_costCenter_Year())
      FPeriod =  as.integer( var_mrpt_audit_md_costCenter_Period())
      data_summary <- mrptpkg::md_costCenter_audit_summary(conn = conn,FYear = FYear,FPeriod = FPeriod)
      names(data_summary) <-c('财务伙伴','成本中心类型','分配总比例','记录数')
      return(data_summary)
      
    })
    
    
    observeEvent(input$mrpt_audit_md_costCenter_btn,{
      
      output$mrpt_audit_md_costCenter_summary <- DT::renderDataTable(data_md_costCenter_summary(),selection = 'single')
      
    })
    
    
    
    
    drilldata_detail_costCenter <- reactive({
      FYear =  as.integer(var_mrpt_audit_md_costCenter_Year())
      FPeriod =  as.integer( var_mrpt_audit_md_costCenter_Period())
      shiny::validate(
        need(length(input$mrpt_audit_md_costCenter_summary_rows_selected) > 0, "请选中任意一行")
      )    
      data_summary <- data_md_costCenter_summary()
      FFinancialPartner  <- data_summary[as.integer(input$mrpt_audit_md_costCenter_summary_rows_selected), '财务伙伴']
      FType  <- data_summary[as.integer(input$mrpt_audit_md_costCenter_summary_rows_selected), '成本中心类型']
      data_detail1 <- mrptpkg::md_costCenter_audit_detail(conn = conn,FYear = FYear,FPeriod = FPeriod,FFinancialPartner = FFinancialPartner,FType = FType)
      names(data_detail1) <- c('财务伙伴','成本中心类型','品牌','渠道','分配总比例','记录数')
      return(data_detail1)
      
    })
    
    output$mrpt_audit_md_costCenter_detail <- DT::renderDataTable(drilldata_detail_costCenter(),selection = 'single')
    
    drilldata2_costCenter_detail_owned <- reactive({
      FYear =  as.integer(var_mrpt_audit_md_costCenter_Year())
      FPeriod =  as.integer( var_mrpt_audit_md_costCenter_Period())
      shiny::validate(
        need(length(input$mrpt_audit_md_costCenter_detail_rows_selected) > 0, "请选中任意一行")
      )    
      data1 = drilldata_detail_costCenter()
      FBrand <- data1[as.integer(input$mrpt_audit_md_costCenter_detail_rows_selected), '品牌']
      #print(FCostItemNumber)
      FChannel <- data1[as.integer(input$mrpt_audit_md_costCenter_detail_rows_selected), '渠道']
      #print(FCostCenterNo)
      data_detail2 <- mrptpkg::md_costCenter_audit_detail_owned(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand2 = FBrand,FChannel2 = FChannel)
      names(data_detail2) <- c('成本中心代码','类型','分配比例','品牌','渠道','分配类型')
      return(data_detail2)
      
    })
    
    #print(drilldata2())
    
    output$mrpt_audit_md_costCenter_detail_owned <- DT::renderDataTable(drilldata2_costCenter_detail_owned(),selection = 'single')
    drilldata2_costCenter_detail_shared <- reactive({
      FYear =  as.integer(var_mrpt_audit_md_costCenter_Year())
      FPeriod =  as.integer( var_mrpt_audit_md_costCenter_Period())
      shiny::validate(
        need(length(input$mrpt_audit_md_costCenter_detail_rows_selected) > 0, "请选中任意一行")
      )    
      data1 = drilldata_detail_costCenter()
      FBrand <- data1[as.integer(input$mrpt_audit_md_costCenter_detail_rows_selected), '品牌']
      #print(FCostItemNumber)
      FChannel <- data1[as.integer(input$mrpt_audit_md_costCenter_detail_rows_selected), '渠道']
      #print(FCostCenterNo)
      data_detail2 <- mrptpkg::md_costCenter_audit_detail_shared(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand2 = FBrand,FChannel2 = FChannel)
      names(data_detail2) <- c('成本中心代码','类型','分配比例','品牌','渠道','分配类型')
      return(data_detail2)
      
    })
    
    #print(drilldata2())
    
    output$mrpt_audit_md_costCenter_detail_shared <- DT::renderDataTable(drilldata2_costCenter_detail_shared(),selection = 'single')
    
    drilldata3_costCenter_detail_shared_list <- reactive({
      FYear =  as.integer(var_mrpt_audit_md_costCenter_Year())
      FPeriod =  as.integer( var_mrpt_audit_md_costCenter_Period())
      shiny::validate(
        need(length(input$mrpt_audit_md_costCenter_detail_shared_rows_selected) > 0, "请选中任意一行")
      )    
      data2 = drilldata2_costCenter_detail_shared()
      FCostCenter <- data2[as.integer(input$mrpt_audit_md_costCenter_detail_shared_rows_selected), '成本中心代码']
      
     
      data_detail3 <- mrptpkg::md_costCenter_audit_detail_shared_list(conn = conn,FYear = FYear,FPeriod = FPeriod,FCostCenter = FCostCenter)
      names(data_detail3) <- c('成本中心代码','类型','分配比例','品牌','渠道','分配类型')
      return(data_detail3)
      
    })
    
    #print(drilldata2())
    
    output$mrpt_audit_md_costCenter_detail_list <- DT::renderDataTable(drilldata3_costCenter_detail_shared_list(),selection = 'single')
    
    #报表反查------
    var_audit_FI_RPA_Year <- var_text('audit_FI_RPA_Year')
    var_audit_FI_RPA_Period<- var_integer('audit_FI_RPA_Period')
    #显示差异值
    var_audit_onlyError_value <-var_numeric('audit_onlyError_value')
    data_audit_FI_RPA_summary <- eventReactive(input$audit_FI_RPA_btn,{
      FYear =  as.integer(var_audit_FI_RPA_Year())
      FPeriod =  as.integer( var_audit_FI_RPA_Period())
      FErrorValue = var_audit_onlyError_value()
      print(FYear)
      print(FPeriod)
      #测试相关的差异功能
      print(FErrorValue)
      print(input$audit_onlyError_btn)
      
      data_summary <- mrptpkg::audit_fi_rpa_brandChannel(conn = conn,FYear = FYear,FPeriod = FPeriod)
      names(data_summary) <- c('品牌','渠道')
      return(data_summary)
    })
    
    observeEvent(input$audit_FI_RPA_btn,{
      output$audit_FI_RPA_summary <- DT::renderDataTable(data_audit_FI_RPA_summary(),selection = 'single')
      #updateTabsetPanel(session = session,inputId = 'tabSet_rptTraceBack',selected = '管报反查-报表项目')
   

    })
    
    #展开了相应的管理报表
    drilldata_audit_FI_RPA_detail <- reactive({
      FYear =  as.integer(var_audit_FI_RPA_Year())
      FPeriod =  as.integer( var_audit_FI_RPA_Period())
      FErrorValue = var_audit_onlyError_value()
      FOnlyError =  input$audit_onlyError_btn
      shiny::validate(
        need(length(input$audit_FI_RPA_summary_rows_selected) > 0, "请选中任意一行")
      )    
      data_summary <- data_audit_FI_RPA_summary()
      FBrand  <- data_summary[as.integer(input$audit_FI_RPA_summary_rows_selected), '品牌']
      FChannel <- data_summary[as.integer(input$audit_FI_RPA_summary_rows_selected), '渠道']
      data_detail1 <- mrptpkg::audit_fi_rpa_rpt(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel,FOnlyError = FOnlyError,FErrorValue = FErrorValue)
      names(data_detail1) <- c('品牌','渠道','报表项目代码','报表项目名称','手工金额（调整后）','RPA当期金额','RPA差异','手工金额(调整前)','手工调整原因','1-SAP汇总金额','2-BW汇总金额','3-手调汇总金额','前2项小计','3项合计')
     
      return(data_detail1)
      
    })
    
    output$audit_FI_RPA_detail <- DT::renderDataTable(drilldata_audit_FI_RPA_detail(),selection = 'single')
    
    #添加下载表的功能
    observeEvent(input$audit_FI_RPA_summary_rows_selected,{
      updateTabsetPanel(session = session,inputId ='tabSet_rptTraceBack' ,selected = '管报反查-报表项目')
      FYear =  as.integer(var_audit_FI_RPA_Year())
      FPeriod =  as.integer( var_audit_FI_RPA_Period())
      data_summary <- data_audit_FI_RPA_summary()
      FBrand  <- data_summary[as.integer(input$audit_FI_RPA_summary_rows_selected), '品牌']
      FChannel <- data_summary[as.integer(input$audit_FI_RPA_summary_rows_selected), '渠道']
      var_file_name = paste0("管报反查表_",FBrand,FChannel,"_",as.character(FYear*100+FPeriod),'.xlsx')
      
      run_download_xlsx(id = 'audit_FI_RPA_dl',data = drilldata_audit_FI_RPA_detail(),filename = var_file_name)
    })

    
    #添加修改操作
    observeEvent(input$audit_FI_RPA_detail_rows_selected,{
      FYear =  as.integer(var_audit_FI_RPA_Year())
      FPeriod =  as.integer( var_audit_FI_RPA_Period())
      data_detail <- drilldata_audit_FI_RPA_detail()
      FBrand  <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '品牌']
      FChannel <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '渠道']
      FRptItemNumber <-data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '报表项目代码']
      info <- mrptpkg::audit_fi_rpa_getValue(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel,FRptItemNumber = FRptItemNumber)
      print(input$audit_FI_RPA_detail_rows_selected)
      if(length(FBrand) >0){
        output$audit_FI_RPA_detail_action <- renderUI(
          tagList(
            mdl_text(id = 'audit_FI_RPA_detail_action1',label = '手工金额(调整后)',value = as.character(info$FRptAmt)),
            mdl_text(id = 'audit_FI_RPA_detail_action2',label = '调整原因',value = as.character(info$FRemark)),
            fluidRow(column(6, mdl_password(id = 'audit_FI_RPA_detail_action3',label = '提交密码')),
                     column(6,tagList(br(),actionButton(inputId ='audit_FI_RPA_detail_action4','提交服务器' ))))
           
            
            
          )
          
        )
      }else{
        output$audit_FI_RPA_detail_action <- renderUI({
          tags$h4('没有选中任意一行报表项目')
        })
        
      }

      
    })
    
    #添加提交功能
    var_audit_FI_RPA_detail_action1 <- var_text('audit_FI_RPA_detail_action1')
    var_audit_FI_RPA_detail_action2 <- var_text('audit_FI_RPA_detail_action2')
    var_audit_FI_RPA_detail_action3 <- var_password('audit_FI_RPA_detail_action3')
    observeEvent(input$audit_FI_RPA_detail_action4,{
      FYear =  as.integer(var_audit_FI_RPA_Year())
      FPeriod =  as.integer( var_audit_FI_RPA_Period())
      data_detail <- drilldata_audit_FI_RPA_detail()
      FBrand  <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '品牌']
      FChannel <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '渠道']
      FRptItemNumber <-data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '报表项目代码']
      FRptAmt <- var_audit_FI_RPA_detail_action1()
      FRemark <- var_audit_FI_RPA_detail_action2()
      FPWD = var_audit_FI_RPA_detail_action3()
      print(FYear)
      print(FPeriod)
      print(FBrand)
      print(FChannel)
      
      if(length(FBrand) >0){
        if(FPWD == 'asd'){
          
          try(
            mrptpkg::audit_fi_rpa_setValue(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel,
                                           FRptItemNumber = FRptItemNumber,FRptAmt = FRptAmt,FRemark = FRemark
            )
          )
          
          pop_notice('更新成功')
          
        }else{
          pop_notice('提交密码有误,请重新输入或联系管理员!') 
        }
      }else{
        pop_notice('请选中一行!') 
      }
      
      

    })
    
    
    # 反查到SAP凭证
    drilldata_detail_SAP <- reactive({
      FYear =  as.integer(var_audit_FI_RPA_Year())
      FPeriod =  as.integer( var_audit_FI_RPA_Period())
      shiny::validate(
        need(length(input$audit_FI_RPA_detail_rows_selected) > 0, "请选中任意一行")
      )    
      data_detail <- drilldata_audit_FI_RPA_detail()
      FBrand  <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '品牌']
      FChannel <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '渠道']
      FRptItemNumber <-data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '报表项目代码']
      data_detail1 <- mrptpkg::audit_detail_fromDS1_SAP(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel,FRptItemNumber = FRptItemNumber)
      ncount <- nrow(data_detail1)
      if (ncount >0){
        names(data_detail1) <- c('年份','月份','品牌','渠道','报表项目代码','报表项目名称',
                                 
                                 '当期金额','数据源','成本中心代码','成本要素代码','凭证号','凭证金额','费用类型','统一费用名称','费用比率','分配类型','成本中心类型','品牌渠道')
      }
      
      return(data_detail1)
      
    })
    #显示筛选的选择
    
    output$audit_FI_RPA_detail_SAP <- DT::renderDataTable(drilldata_detail_SAP(),selection = 'single')
    
    
    
    
    
    # 更新数据选择
     observeEvent(input$audit_FI_RPA_detail_rows_selected,{
       data <- drilldata_detail_SAP()
       ncount <- nrow(data)
       if (ncount >0){
         FYear = as.integer(data[1,'年份'])
         FPeriod = as.integer(data[1,'月份'])
         FYearPeriod = as.character(FYear*100+FPeriod)
         FBrand = data[1,'品牌']
         FChannel = data[1,'渠道']
         FRptItemNumber =data[1,'报表项目代码']
         file_name_xlsx = paste0('管报过程表_',FBrand,FChannel,'_',FYearPeriod,'_',FRptItemNumber,'_SAP凭证数据源.xlsx')
         run_download_xlsx(id = 'audit_FI_RPA_detail_SAP_dl',data = drilldata_detail_SAP(),filename = file_name_xlsx)
         #启用SAP 凭证分析功能
         output$col_selection_holder <- renderUI({
           dragulaInput(
             inputId = "col_selection",
             sourceLabel = "列标题",
             targetsLabels = c("行", "列","值"),
             choices = names(data),
             width = "650px"
           )
           
         })
         #启用运算功能-----
         observeEvent(input$traceBack_sap_crossTable_run,{
           row_holder = input$col_selection$target$`行`
           row_flag = is.null(row_holder)
           row_flag2 =  !row_flag
           
           if(row_flag){
             #pop_notice('请选择一列维度用于分析')
           }
           
           #列可以为空
           column_holder = input$col_selection$target$`列`
           col_flag = is.null(column_holder)
           if(col_flag){
             column_holder = ''
           }
           
           
           value_hoder = input$col_selection$target$`值`
           value_flag = is.null(value_hoder)
           value_flag2 = !value_flag
           if(value_flag){
              #pop_notice('请选择一列数值列用于计算')
           }else{
             if(length(value_hoder) >1){
              # pop_notice('只支持分析一列数值列')
             }
           }
           
          fun_name = input$formula_selection$target$`设置公式`
          
          margin_flag = input$traceBack_sap_addMargins
          
          if(row_flag2 & value_flag2 ){
            #print('ana1')
            #print(data)
            data_analysis_sap <-tsdo::df_crossTable_run(data = data,row_holder = row_holder,column_holder = column_holder,
                                                        value_hoder = value_hoder,fun_name = fun_name,margins = margin_flag)
            #print(data_analysis_sap)
            #print('ana2')
            #run_dataTable2('traceBack_ana_SAP',data = data_analysis_sap)   
            output$traceBack_ana_SAP <- DT::renderDataTable(data_analysis_sap,selection  = 'single')
            #添加下载功能
            file_name_xlsx2 = paste0('管报过程表_',FBrand,FChannel,'_',FYearPeriod,'_',FRptItemNumber,'_SAP凭证数据透视表.xlsx')
            run_download_xlsx(id = 'traceBack_sap_crossTable_dl',data =data_analysis_sap,filename = file_name_xlsx2 )
          }
           
           
           
    
           
           
         })
         
         
         
         
       }else{
         # pop_notice('不存在SAP数据源')
       }
      
       
     })
    #反查手调凭证
     drilldata_detail_ADJ <- reactive({
       FYear =  as.integer(var_audit_FI_RPA_Year())
       FPeriod =  as.integer( var_audit_FI_RPA_Period())
       shiny::validate(
         need(length(input$audit_FI_RPA_detail_rows_selected) > 0, "请选中任意一行")
       )    
       data_detail <- drilldata_audit_FI_RPA_detail()
       FBrand  <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '品牌']
       FChannel <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '渠道']
       FRptItemNumber <-data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '报表项目代码']
       data_detail1 <- mrptpkg::audit_detail_fromDS1_ADJ(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel,FRptItemNumber = FRptItemNumber)
       ncount <- nrow(data_detail1)
       if (ncount >0){
         names(data_detail1) <- c('年份','月份','品牌','渠道','报表项目代码','报表项目名称',
                                  
                                  '当期金额','数据源','成本中心代码','成本要素代码','凭证号','凭证金额','费用类型','统一费用名称','费用比率','分配类型','成本中心类型','品牌渠道')
       }
       
       return(data_detail1)
       
     })
     #显示筛选的选择
     
     output$audit_FI_RPA_detail_ADJ <- DT::renderDataTable(drilldata_detail_ADJ(),selection = 'single')
     # 更新数据选择
     observeEvent(input$audit_FI_RPA_detail_rows_selected,{
       data <- drilldata_detail_ADJ()
       ncount <- nrow(data)
       if (ncount >0){
         FYear = as.integer(data[1,'年份'])
         FPeriod = as.integer(data[1,'月份'])
         FYearPeriod = as.character(FYear*100+FPeriod)
         FBrand = data[1,'品牌']
         FChannel = data[1,'渠道']
         FRptItemNumber =data[1,'报表项目代码']
         file_name_xlsx = paste0('管报过程表_',FBrand,FChannel,'_',FYearPeriod,'_',FRptItemNumber,'_手调凭证数据源.xlsx')
         run_download_xlsx(id = 'audit_FI_RPA_detail_ADJ_dl',data = drilldata_detail_ADJ(),filename = file_name_xlsx)
       }else{
         # pop_notice('不存在手调凭证数据源')
       }
       
       
     })
     
     #BW报表
     
     drilldata_detail_BW <- reactive({
       FYear =  as.integer(var_audit_FI_RPA_Year())
       FPeriod =  as.integer( var_audit_FI_RPA_Period())
       shiny::validate(
         need(length(input$audit_FI_RPA_detail_rows_selected) > 0, "请选中任意一行")
       )    
       data_detail <- drilldata_audit_FI_RPA_detail()
       FBrand  <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '品牌']
       FChannel <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '渠道']
       FRptItemNumber <-data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '报表项目代码']
       data_detail1 <- mrptpkg::audit_detail_fromDS1_BW(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel,FRptItemNumber = FRptItemNumber)
       ncount <- nrow(data_detail1)
       if (ncount >0){
         names(data_detail1) <- c('年份','月份','品牌','渠道','报表项目代码','报表项目名称','当期金额','数据源','方案代码','子方案号','指标类型',
                                  'F13物料组代码','F13物料组名称','F14品牌代码','F14品牌名称','F30客户代码','F30客户名称',
                                  'F33子渠道代码','F33子渠道名称','F37地区销售部代码','F37地区销售部名称','41分析用渠道',
                                  'F61成本中心控制代码','F61成本中心控制名称','报表金额','费用类型','统一费用名称','费用比率','分配类型','成本中心类型','品牌渠道')
       }
       
       return(data_detail1)
       
     })
     #显示筛选的选择
     
     output$audit_FI_RPA_detail_BW <- DT::renderDataTable(drilldata_detail_BW(),selection = 'single')
     #报表过程表-BW规则表反查------
     
     drilldata_rule_BW <- reactive({
       FYear =  as.integer(var_audit_FI_RPA_Year())
       FPeriod =  as.integer( var_audit_FI_RPA_Period())
       shiny::validate(
         need(length(input$audit_FI_RPA_detail_rows_selected) > 0, "请选中任意一行")
       )    
       data_detail <- drilldata_audit_FI_RPA_detail()
       FBrand  <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '品牌']
       FChannel <- data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '渠道']
       FRptItemNumber <-data_detail[as.integer(input$audit_FI_RPA_detail_rows_selected), '报表项目代码']
       print('back-trace')
       print(FYear)
       print(FPeriod)
       print(FBrand)
       print(FChannel)
       print(FRptItemNumber)
       data_detail3 <- mrptpkg::audit_rule_bw(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel,FRptItemNumber = FRptItemNumber)

       
       print(data_detail3)    
       return(data_detail3)
       
     })
     output$audit_rule_BW <- DT::renderDataTable(drilldata_rule_BW(),selection = 'single')
     #显示修改界面------
     observeEvent(input$audit_rule_bw_update,{
       #获取数据处理选择
       data =drilldata_rule_BW()
       #选中一行数据
       shiny::validate(
         need(length(input$audit_rule_BW_rows_selected) > 0, "请选中任意一行")
       ) 
       row_selected = as.integer(input$audit_rule_BW_rows_selected)
       
       showModal(modalDialog(title = paste0("修改BW规则表"),
                             tagList(
                               
                               fluidRow(column(width = 6,mdl_text(id = 'bwu_FSolutionNumber',label = '方案号',value = data[row_selected,'方案号'])),
                                        column(width = 6,mdl_text(id = 'bwu_FSubNumber',label = '方案序号',value = as.character(data[row_selected,'方案序号'])))),
                              
                               fluidRow(column(width = 6,mdl_text(id = 'bwu_F13_ItemGroupName_in',label = '13物料组(物料主数据)-名称-包含',value = tsdo::na_replace(data[row_selected,'13物料组(物料主数据)-名称-包含'],''))),
                                        column(width = 6,mdl_text(id = 'bwu_F13_ItemGroupName_Notin',label = '13物料组(物料主数据)-名称-排除',value = tsdo::na_replace(data[row_selected,'13物料组(物料主数据)-名称-排除'],'')))),
                               # 
                               fluidRow(column(width = 6,mdl_text(id = 'bwu_F14_brandName_in',label = '14品牌(物料主数据)-名称-包含',value = tsdo::na_replace(data[row_selected,'14品牌(物料主数据)-名称-包含'],''))),
                                        column(width = 6,mdl_text(id = 'bwu_F14_brandName_Notin',label = '14品牌(物料主数据)-名称-排除',value = tsdo::na_replace(data[row_selected,'14品牌(物料主数据)-名称-排除'],'')))),
                               # 
                               fluidRow(column(width = 6,textAreaInput(inputId = 'bwu_F30_customerNumber_in',label = '30客户-代码-包含',value = na_replace(data[row_selected,'30客户-代码-包含'],''))),
                                        column(width = 6,textAreaInput(inputId = 'bwu_F30_customerNumber_Notin',label = '30客户-代码-排除',value = na_replace(data[row_selected,'30客户-代码-排除'],'')))),
                               # 
                               fluidRow(column(width = 6,mdl_text(id = 'bwu_F33_subChannelName_in',label = '33子渠道（SAP客户组）(客户主数据)-名称-包含',value = na_replace(data[row_selected,'33子渠道（SAP客户组）(客户主数据)-名称-包含'],''))),
                                        column(width = 6,mdl_text(id = 'bwu_F33_subChannelName_Notin',label = '33子渠道（SAP客户组）(客户主数据)-名称-排除',value = na_replace(data[row_selected,'33子渠道（SAP客户组）(客户主数据)-名称-排除'],'')))),
                               # 
                               fluidRow(column(width = 6,mdl_text(id = 'bwu_F37_disctrictSaleDeptName_in',label = '37地区销售部(客户主数据)-名称-包含',value = na_replace(data[row_selected,'37地区销售部(客户主数据)-名称-包含'],''))),
                                        column(width = 6,mdl_text(id = 'bwu_F37_disctrictSaleDeptName_Notin',label = '37地区销售部(客户主数据)-名称-排除',value = na_value(data[row_selected,'37地区销售部(客户主数据)-名称-排除'],'')))),
                               # 
                               fluidRow(column(width = 6,mdl_text(id = 'bwu_F41_channelName_in',label = '41渠道(分析用)-名称-包含',value = na_replace(data[row_selected,'41渠道(分析用)-名称-包含'],''))),
                                        column(width = 6,mdl_text(id = 'bwu_F41_channelName_Notin',label = '41渠道(分析用)-名称-排除',value = na_replace(data[row_selected,'41渠道(分析用)-名称-排除'],'')))),
                               # 
                               fluidRow(column(width = 6,mdl_text(id = 'bwu_F61_costCenterControlNumber_in',label = '61成本中心(控制)-代码-包含',value = na_replace(data[row_selected,'61成本中心(控制)-代码-包含'],''))),
                                        column(width = 6,mdl_text(id = 'bwu_F61_costCenterControlNumber_Notin',label = '61成本中心(控制)-代码-排除',value = na_replace(data[row_selected,'61成本中心(控制)-代码-排除'],'')))),
                               # 
                               fluidRow(column(width = 6,mdl_text(id = 'bwu_FValueType',label = '指标名称',value = na_replace(data[row_selected,'指标名称'],''))),
                                        column(width = 6,mdl_text(id = 'bwu_FRate',label = '分配比例',value = na_replace(as.character(data[row_selected,'分配比例']),'')))),
                    
                               fluidRow(column(width = 6,mdl_text(id = 'bwu_FSolutionName',label = '方案名称',value = na_replace(data[row_selected,'方案名称'],''))),
                                        column(width = 6,mdl_text(id = 'bwu_FDescription',label = '方案描述',value = na_replace(data[row_selected,'方案描述'],''))))
                               
                             ),
                             
                             
                             
                             footer = column(shiny::modalButton('取消'),
                                             shiny::actionButton('bw_update_save', '保存'),
                                             width=12),
                             size = 'l'
       ))
       
     })
     
     # 保存BW规则修改内容-------
     var_bwu_F13_ItemGroupName_in <- var_text('bwu_F13_ItemGroupName_in')
     var_bwu_F13_ItemGroupName_Notin <- var_text('bwu_F13_ItemGroupName_Notin')
     var_bwu_F14_brandName_in <- var_text('bwu_F14_brandName_in')
     var_bwu_F14_brandName_Notin <- var_text('bwu_F14_brandName_Notin')
     var_bwu_F33_subChannelName_in <- var_text('bwu_F33_subChannelName_in')
     var_bwu_F33_subChannelName_Notin <- var_text('bwu_F33_subChannelName_Notin')
     var_bwu_F37_disctrictSaleDeptName_in =var_text('bwu_F37_disctrictSaleDeptName_in')
     var_bwu_F37_disctrictSaleDeptName_Notin = var_text('bwu_F37_disctrictSaleDeptName_Notin')
     var_bwu_F41_channelName_in = var_text('bwu_F41_channelName_in')
     var_bwu_F41_channelName_Notin = var_text('bwu_F41_channelName_Notin')
     var_bwu_F61_costCenterControlNumber_in = var_text('bwu_F61_costCenterControlNumber_in')
     var_bwu_F61_costCenterControlNumber_Notin = var_text('bwu_F61_costCenterControlNumber_Notin')
     var_bwu_FValueType = var_text('bwu_FValueType')
     var_bwu_FRate = var_text('bwu_FRate')
     var_bwu_FSolutionName = var_text('bwu_FSolutionName')
     var_bwu_FDescription = var_text('bwu_FDescription')
     
     
     
     observeEvent(input$bw_update_save,{
       data =drilldata_rule_BW()
       #选中一行数据
       shiny::validate(
         need(length(input$audit_rule_BW_rows_selected) > 0, "请选中任意一行")
       ) 
       row_selected = as.integer(input$audit_rule_BW_rows_selected)
       FYear = data[row_selected,'年份']
       FPeriod =data[row_selected,'月份']
       FSolutionNumber = data[row_selected,'方案号']
       FSubNumber = as.integer(data[row_selected,'方案序号'])
       F13_ItemGroupName_in = tsdo::sql_str2(var_bwu_F13_ItemGroupName_in())
       #print(F13_ItemGroupName_in)
       F13_ItemGroupName_Notin = tsdo::sql_str2(var_bwu_F13_ItemGroupName_Notin())
       #print(F13_ItemGroupName_Notin)
       F14_brandName_in = tsdo::sql_str2(var_bwu_F14_brandName_in())
       F14_brandName_Notin =tsdo::sql_str2(var_bwu_F14_brandName_Notin())
       F30_customerNumber_in = tsdo::sql_str2(input$bwu_F30_customerNumber_in)
       print(F30_customerNumber_in)
       F30_customerNumber_Notin = tsdo::sql_str2(input$bwu_F30_customerNumber_Notin)
       print(F30_customerNumber_Notin)
       F33_subChannelName_in = tsdo::sql_str2(var_bwu_F33_subChannelName_in())
       F33_subChannelName_Notin =tsdo::sql_str2(var_bwu_F33_subChannelName_Notin())
       F37_disctrictSaleDeptName_in = tsdo::sql_str2(var_bwu_F37_disctrictSaleDeptName_in())
       F37_disctrictSaleDeptName_Notin = tsdo::sql_str2(var_bwu_F37_disctrictSaleDeptName_Notin())
       F41_channelName_in = tsdo::sql_str2(var_bwu_F41_channelName_in())
       F41_channelName_Notin = tsdo::sql_str2(var_bwu_F41_channelName_Notin())
       F61_costCenterControlNumber_in = tsdo::sql_str2(var_bwu_F61_costCenterControlNumber_in())
       F61_costCenterControlNumber_Notin =tsdo::sql_str2(var_bwu_F61_costCenterControlNumber_Notin())
       FValueType = tsdo::sql_str2(var_bwu_FValueType())
       FRate = as.numeric(var_bwu_FRate())
       FSolutionName = tsdo::sql_str2(var_bwu_FSolutionName())
       FDescription = tsdo::sql_str2(var_bwu_FDescription())
       sql <- paste0("update a   set 
a.F13_ItemGroupName_in =  ",F13_ItemGroupName_in,",
a.F13_ItemGroupName_Notin =  ",F13_ItemGroupName_Notin," ,
a.F14_brandName_in =  ",F14_brandName_in,",
a.F14_brandName_Notin =  ",F14_brandName_Notin,",
a.F30_customerNumber_in = ",F30_customerNumber_in,",
a.F30_customerNumber_Notin =  ",F30_customerNumber_Notin,",
a.F33_subChannelName_in =  ",F33_subChannelName_in,",
a.F33_subChannelName_Notin =  ",F33_subChannelName_Notin,",
a.F37_disctrictSaleDeptName_in = ",F37_disctrictSaleDeptName_in,",
a.F37_disctrictSaleDeptName_Notin = ",F37_disctrictSaleDeptName_Notin,",
a.F41_channelName_in =  ",F41_channelName_in,",
a.F41_channelName_Notin = ",F41_channelName_Notin,",
a.F61_costCenterControlNumber_in = ",F61_costCenterControlNumber_in,",
a.F61_costCenterControlNumber_Notin = ",F61_costCenterControlNumber_Notin,",
a.FValueType =  ",FValueType,",
a.FRate =  ",FRate,",
a.FSolutionName =  ",FSolutionName,",
a.FDescription = ",FDescription,"
from  t_mrpt_rule_bw2 a
 where FYear = ",FYear," and FPeriod = ",FPeriod," 
and FSolutionNumber ='",FSolutionNumber,"' and FSubNumber = ",FSubNumber,"")
       #print(sql)
       #cat(sql)
  
    tsda::sql_update(conn,sql)
    #取消窗口
    shiny::removeModal()
       
       
       
       
       
       
       
     })
     
     
     
     
     # 更新数据选择
     observeEvent(input$audit_FI_RPA_detail_rows_selected,{
       data <- drilldata_detail_BW()
       ncount <- nrow(data)
       if (ncount >0){
         FYear = as.integer(data[1,'年份'])
         FPeriod = as.integer(data[1,'月份'])
         FYearPeriod = as.character(FYear*100+FPeriod)
         FBrand = data[1,'品牌']
         FChannel = data[1,'渠道']
         FRptItemNumber =data[1,'报表项目代码']
         file_name_xlsx = paste0('管报过程表_',FBrand,FChannel,'_',FYearPeriod,'_',FRptItemNumber,'_BW报表数据源.xlsx')
         run_download_xlsx(id = 'audit_FI_RPA_detail_BW_dl',data = drilldata_detail_BW(),filename = file_name_xlsx)
         
         
         #启用SAP 凭证分析功能
         output$col_selection_holder_bw <- renderUI({
           dragulaInput(
             inputId = "col_selection_bw",
             sourceLabel = "列标题",
             targetsLabels = c("行", "列","值"),
             choices = names(data),
             width = "650px",
             height = '150px'
           )
           
         })
         #启用运算功能-----
         observeEvent(input$traceBack_bw_crossTable_run,{
           row_holder = input$col_selection_bw$target$`行`
           row_flag = is.null(row_holder)
           row_flag2 =  !row_flag
           
           if(row_flag){
             #pop_notice('请选择一列维度用于分析')
           }
           
           #列可以为空
           column_holder = input$col_selection_bw$target$`列`
           col_flag = is.null(column_holder)
           if(col_flag){
             column_holder = ''
           }
           
           
           value_hoder = input$col_selection_bw$target$`值`
           value_flag = is.null(value_hoder)
           value_flag2 = !value_flag
           if(value_flag){
             #pop_notice('请选择一列数值列用于计算')
           }else{
             if(length(value_hoder) >1){
               # pop_notice('只支持分析一列数值列')
             }
           }
           
           fun_name = input$formula_selection_bw$target$`设置公式`
           
           margin_flag = input$traceBack_bw_addMargins
           
           if(row_flag2 & value_flag2 ){
             #print('ana1')
             #print(data)
             data_analysis_bw <-tsdo::df_crossTable_run(data = data,row_holder = row_holder,column_holder = column_holder,
                                                         value_hoder = value_hoder,fun_name = fun_name,margins = margin_flag)
             #print(data_analysis_sap)
             #print('ana2')
             #run_dataTable2('traceBack_ana_SAP',data = data_analysis_sap)   
             output$traceBack_ana_bw <- DT::renderDataTable(data_analysis_bw,selection  = 'single')
             #添加下载功能
             file_name_xlsx2 = paste0('管报过程表_',FBrand,FChannel,'_',FYearPeriod,'_',FRptItemNumber,'_BW报表证数据透视表.xlsx')
             run_download_xlsx(id = 'traceBack_bw_crossTable_dl',data =data_analysis_bw,filename = file_name_xlsx2 )
           }
           
           
           
           
           
           
         })
         
         
       }else{
         # pop_notice('不存在BW报表数据源')
       }
       
       #针对BW处理规则----
       data_rule_bw <- drilldata_rule_BW()
       ncount2 <- nrow(data_rule_bw)
       if(ncount2 >0){
         
         FYear = as.integer(data[1,'年份'])
         FPeriod = as.integer(data[1,'月份'])
         FYearPeriod = as.character(FYear*100+FPeriod)
         FBrand = data[1,'品牌']
         FChannel = data[1,'渠道']
         FRptItemNumber =data[1,'报表项目代码']
         file_name_xlsx2 = paste0('管报反查_BW规则表_',FBrand,FChannel,'_',FYearPeriod,'_',FRptItemNumber,'.xlsx')
         run_download_xlsx(id = 'audit_rule_BW_dl',data = data_rule_bw,filename = file_name_xlsx2)
         
       }
       
       
       
     })
     
     #重分类凭证按凭证号查询--------
     var_voucher_audit_afterReclass_Year2 <- var_text('voucher_audit_afterReclass_Year2')
     var_voucher_audit_afterReclass_Period2 <- var_integer('voucher_audit_afterReclass_Period2')
     var_voucher_audit_afterReclass_vchNo2 <- var_text('voucher_audit_afterReclass_vchNo2')
     observeEvent(input$voucher_audit_afterReclass_btn2,{
       FYear = as.integer(var_voucher_audit_afterReclass_Year2())
       FPeriod = as.integer(var_voucher_audit_afterReclass_Period2())
       FVchNo = var_voucher_audit_afterReclass_vchNo2()
       print(FYear)
       print(FPeriod)
       print(FVchNo)
       data <- mrptpkg::voucher_afterReClass_vchNo_list(conn = conn,FYear = FYear,FPeriod = FPeriod,FVchNo = FVchNo)
       print(data)
       ncount =nrow(data)
       if(ncount >0){
         names(data) <- c('凭证日期','过账日期','成本中心代码','成本中心名称','成本要素代码1','成本要素名称1','凭证金额','凭证摘要','重分类代码','凭证号','成本要素代码2','成本要素名称2','成本要素代码','成本要素名称')
         run_dataTable2('voucher_audit_afterReclass_dataView2',data = data)
         var_file_name = paste0("按凭证号查询_",as.character(FYear*100+FPeriod),'_',FVchNo,'.xlsx')
         run_download_xlsx(id = 'voucher_audit_afterReclass_dl2',data = data,filename = var_file_name )
         
         
       }else{
         
         pop_notice('未查询到凭证数据，请检查一下凭证号是否有误')
         
         
       }
       
       
       
     })
     #管报过程表查询
 
     var_audit_FI_RPA_Year3 <- var_text('audit_FI_RPA_Year3')
     var_audit_FI_RPA_Period3<- var_integer('audit_FI_RPA_Period3')
     data_audit_FI_RPA_summary3 <- eventReactive(input$audit_FI_RPA_btn3,{
       FYear =  as.integer(var_audit_FI_RPA_Year3())
       FPeriod =  as.integer( var_audit_FI_RPA_Period3())
       print(FYear)
       print(FPeriod)
       data_summary <- mrptpkg::audit_fi_rpa_brandChannel(conn = conn,FYear = FYear,FPeriod = FPeriod)
       names(data_summary) <- c('品牌','渠道')
       return(data_summary)
     })
     
     observeEvent(input$audit_FI_RPA_btn3,{
       output$audit_FI_RPA_summary3 <- DT::renderDataTable(data_audit_FI_RPA_summary3(),selection = 'single')
       
       
     })
     
     #展开了相应的管理报表
     drilldata_audit_FI_RPA_detail3 <- reactive({
       FYear =  as.integer(var_audit_FI_RPA_Year3())
       FPeriod =  as.integer( var_audit_FI_RPA_Period3())
       shiny::validate(
         need(length(input$audit_FI_RPA_summary3_rows_selected) > 0, "请选中任意一行")
       )    
       data_summary <- data_audit_FI_RPA_summary3()
       FBrand  <- data_summary[as.integer(input$audit_FI_RPA_summary3_rows_selected), '品牌']
       FChannel <- data_summary[as.integer(input$audit_FI_RPA_summary3_rows_selected), '渠道']
       data_detail1 <- mrptpkg::audit_detail_All(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel)
       names(data_detail1) <- c('年份','月份','品牌','渠道','子渠道','报表项目代码','报表项目金额','当期金额','数据源','BW方案号','子方案号','指标类型',
                                'F13物料组代码','F13物料组名称','F14品牌代码','F14品牌名称','F30客户代码','F30客户名称',
                                'F33子渠道代码','F33子渠道名称','F37地区销售部代码','F37地区销售部名称','41分析用渠道',
                                'F61成本中心控制代码','F61成本中心控制名称','成本中心代码','成本要素名称','凭证号','凭证金额',
                                '凭证抬头','渠道费用分配率','成本中心类型','市场费用金额','市场费用分配率')
       return(data_detail1)
       
     })
     
       observeEvent(input$audit_FI_RPA_summary3_rows_selected,{
         data = drilldata_audit_FI_RPA_detail3()
         output$audit_FI_RPA_detail3 <- DT::renderDataTable(data,selection = 'single')
         FYear =  as.integer(var_audit_FI_RPA_Year3())
         FPeriod =  as.integer( var_audit_FI_RPA_Period3())
         FBrand = data[1,'品牌']
         FChannel =data[1,'渠道']
         var_file_name = paste0('管报过程表_',as.character(FYear*100+FPeriod),'_',FBrand,FChannel,'.xlsx')
         run_download_xlsx('audit_FI_RPA_detail_dl3',data = data,filename = var_file_name)
         
       })
       
       #上传手调整凭证-----
       var_adj_upload_file <- var_file('adj_upload_file')
       observeEvent(input[['adj_upload_btn']],{
         #有点意思，显示所有的内容
         #print(names(input)) 
         file_name = var_adj_upload_file()
         if(is.null(file_name)){
           pop_notice('请选择一下手调凭证文件')
         }else{
           res <- jlrdspkg::adj_readData(file = file_name,conn = conn)
           pop_notice('上传服务器成功！')
         }
         
         
       })
       #管报业务规则生效
       observeEvent(input$md_bw_businessRule_activate,{
         FYear = as.integer(var_md_bwRule_FYear())
         FPeriod = as.integer(var_md_bwRule_FPeriod())
         
         try(jlrdspkg::mrpt_md_rule_bw2_dim_allocAll(conn = conn,FYear = FYear,FPeriod = FPeriod))
         tsui::pop_notice('业务规则表生效')
         
       })
       #管报运算
       var_mrpt_run_Year <-var_text('mrpt_run_Year')
       var_mrpt_run_Period <-var_text('mrpt_run_Period')
       #var_mrpt_run_Period <- var_integer('mrpt_run_Period')
       result_val <- reactiveVal()
       observeEvent(input$mrpt_run,{
         shinyjs::disable(id = 'mrpt_run')
         FYear = as.integer(var_mrpt_run_Year())
         FPeriod =as.integer(var_mrpt_run_Period())
         #设置进度条
         progress <- Progress$new(session, min=1, max=10)
         on.exit(progress$close())
         progress$set(message = '步骤1,当前进度10%',
                      detail = '计算BW分配规则',value=1)
         mrpt_md_rule_bw2_dim_allocAll(conn = conn,FYear = FYear,FPeriod = FPeriod)
         progress$set(message = '步骤2,当前进度20%',
                      detail = ':写入SAP数据',value=2)
         mrpt_write_sap(conn = conn,FYear = FYear,FPeriod = FPeriod )
         progress$set(message = '步骤3，当前进度30%',
                      detail = '写入BW数据',value=3)
         bw2_sync_data(conn = conn,FYear = FYear,FPeriod = FPeriod)

           progress$set(message = '步骤4,当前进度40%',
                        detail = '计算BW报表结果,此步骤用时较长...',value=4)
           bw2_deal_list(conn = conn,FYear = FYear,FPeriod = FPeriod)

         progress$set(message = '步骤5,当前进度50%',
                      detail = 'BW处理结果写入表',value=5)
         mrpt_write_bw2(conn = conn,FYear = FYear,FPeriod = FPeriod)
         progress$set(message = '步骤6,当前进度60%',
                      detail = '写入管报分配明细结果',value=6)
         mrpt_res_allocated(conn = conn,FYear = FYear,FPeriod = FPeriod)
         progress$set(message = '步骤7,当前进度70%',
                      detail = '明细渠道计算结果当期数据...',value=7)
         mrpt_res_current(conn = conn,FYear = FYear,FPeriod = FPeriod,simple = FALSE)
         progress$set(message = '步骤8:当前进度80%',
                      detail = '明细渠道计算本年累计数据...',value=8)
         mrpt_res_ytdCumsum(conn = conn,FYear = FYear,FPeriod = FPeriod)
         progress$set(message = '步骤9,当前进度90%',
                      detail = '计算上级事业部当期数据...',value=9)
         graph_rpa_period(conn = conn,FYear = FYear,FPeriod = FPeriod)
         
         progress$set(message = '步骤10:当前进度100%',
                      detail = '计算上级事业部本年累计数据...',value=10)
         mrpt_calc_cumSum_Period_res(conn = conn,FYear = FYear,FPeriod = FPeriod)
      

         
         #jlrdspkg::mrpt_run(conn = conn,FYear = FYear,FPeriod = FPeriod)
         # conn_hana = hana::hana_conn()
         
         #写入管报结果表
         #jlrdspkg::hana_write_res(conn = conn,FYear = FYear,FPeriod = FPeriod)
         #写入管报过程表
         #jlrdspkg::hana_write_detail(conn = conn,FYear = FYear,FPeriod = FPeriod)
         pop_notice('管报运算成功!')
         #pop_notice('管报运算成功并写入BW报表!')
       })
       
       observeEvent(input$mrpt_run_activate,{
         shinyjs::enable('mrpt_run')
       })
       
       #写入BW报表
       #要求在JALA的环境下进行使用
       observeEvent(input$mrpt_to_bw,{
         
         
         FYear = as.integer(var_mrpt_run_Year())
         FPeriod =as.integer(var_mrpt_run_Period())

         #写入管报结果表
         jlrdspkg::hana_write_res(conn = conn,FYear = FYear,FPeriod = FPeriod)
         #写入管报过程表
         jlrdspkg::hana_write_detail(conn = conn,FYear = FYear,FPeriod = FPeriod)
         pop_notice('管报写入成功!')
         
         
       })
       
     
      # #设置选择内容
      #  output$res_formula_selection <- renderPrint({
      #    input$formula_selection$target$`设置公式`
      #  })
      #  
      #  output$res_col_selection <-renderPrint({
      #    input$col_selection$target
      #  })
      
     # 手工管报上传功能----
       var_mrpt_manual_year <- var_text('mrpt_manual_year')
       var_mrpt_manual_period <- var_text('mrpt_manual_period')
       var_mrpt_manual_brand <- var_text('mrpt_manual_brand')
       var_mrpt_manual_channel <- var_text('mrpt_manual_channel')
       #手工管报的查询---
       observeEvent(input$mrpt_manual_query_btn,{
         FBrand <- var_mrpt_manual_brand()
         FChannel <- var_mrpt_manual_channel()
         FYear <-as.integer(var_mrpt_manual_year())
         FPeriod <- as.integer(var_mrpt_manual_period())
         data <- jlrdspkg::mrpt2_manual_query(conn = conn,FBrand = FBrand,FChannel = FChannel,FYear = FYear,FPeriod = FPeriod)
         run_dataTable2('mrpt_manual_dataShow',data = data)
       })
       
       #手工管报上传
       var_mrpt_manual_file <- var_file('mrpt_manual_file')
       observeEvent(input$mrpt_manual_upload,{
         file_name = var_mrpt_manual_file()
         
         if(is.null(file_name)){
           pop_notice('请选择一个文件')
         }else{
           jlrdspkg::mrpt2_manual_read(conn = conn,file_name = file_name)
           pop_notice('已经提交服务器上传')
         }
       })
       
       #中后台费用上传----
       var_mpv_brand <- var_text('mpv_brand')
       var_mpv_channel <- var_text('mpv_channel')
       var_mpv_year <- var_text('mpv_year')
       
       observeEvent(input$mpv_query,{
         FBrand = var_mpv_brand()
         FChannel = var_mpv_channel()
         FYear = as.integer(var_mpv_year())
         data <- jlrdspkg::mpv_query(conn = conn,FBrand = FBrand ,FChannel = FChannel ,FYear = FYear)
         run_dataTable2(id = 'mpv_dataShow',data = data)
         var_fileName =  paste0('中台后费用下载',FYear,'.xlsx')
         run_download_xlsx(id = 'mpv_dl',data = data,filename =var_fileName )
       })

      #上传手工中后费用
       var_mpv_file <- var_file('mpv_file')
       observeEvent(input$mpv_upload,{
         file_name = var_mpv_file()
         if(is.null(file_name)){
           pop_notice('请选择中后台费用文件')
         }else{
           jlrdspkg::mpv_upload(file_name = file_name,conn = conn)
           pop_notice('中后台费用上传成功！')
         }
         
       })
    #添加分析图开sankey------
       observeEvent(input$rbu_brandChannel_graph_btn,{
         
         data_graph = readxl::read_excel("data/jala_graph.xlsx", 
                                                          sheet = "graph")
         output$rbu_brandChannel_graph <- echarts4r::renderEcharts4r({
           
           data_graph %>% 
             e_charts() %>% 
             e_sankey(source, target, value)
           
         })
         
         data_calc = readxl::read_excel("data/jala_graph.xlsx", 
                                         sheet = "calc")
         output$rbu_brandChannel_calc <- echarts4r::renderEcharts4r({
           
           data_calc %>% 
             e_charts() %>% 
             e_sankey(source, target, value)
           
         })
         data_rollup1 = readxl::read_excel("data/jala_graph.xlsx", 
                                        sheet = "rollup1")
         output$rbu_brandChannel_rollup1 <- echarts4r::renderEcharts4r({
           
           data_rollup1 %>% 
             e_charts() %>% 
             e_sankey(source, target, value)
           
         })
         
         
         data_rollup2 = readxl::read_excel("data/jala_graph.xlsx", 
                                           sheet = "rollup2")
         output$rbu_brandChannel_rollup2 <- echarts4r::renderEcharts4r({
           
           data_rollup2 %>% 
             e_charts() %>% 
             e_sankey(source, target, value)
           
         })
         

        
       
         
         
         
         
         
         
         
       })
       #3.01添加管报结果表查询
       var_mrpt_res_year <- var_text('mrpt_res_year')
       var_mrpt_res_period <- var_text('mrpt_res_period')
       var_mrpt_res_brand <- var_text('mrpt_res_brand')
       var_mrpt_res_channel <- var_text('mrpt_res_channel')
       observeEvent(input$mrpt_res_query_btn,{
         FYear = as.integer(var_mrpt_res_year())
         FPeriod = as.integer(var_mrpt_res_period())
         FBrand = var_mrpt_res_brand()
         FChannel = var_mrpt_res_channel()
         
         data = jlrdspkg::mrpt_res_query(conn=conn,FYear = FYear,FPeriod =FPeriod ,FBrand = FBrand,FChannel = FChannel
                                            )
         run_dataTable2('mrpt_res_dataShow',data = data)
         run_download_xlsx(id = 'mrpt_res_dl',data = data,filename = '管报结果表下载.xlsx')
         
       })
       #添加管报的重复性检验
       observeEvent(input$mrpt_res_duplicate_btn,{
         data = jlrdspkg::mrpt_res_checkDuplicate(conn=conn)
         run_dataTable2('mrpt_res_duplicate_dataShow',data)
         
       })
       #管报级次
       var_check_bu_FYear <- var_text('check_bu_FYear')
       var_check_bu_FPeriod <- var_text('check_bu_FPeriod')
       var_check_bu_FBrand <- var_text('check_bu_FBrand')
       var_check_bu_FChannel <- var_text('check_bu_FChannel')
       
       observeEvent(input$check_bu_btn,{
         FYear = as.integer(var_check_bu_FYear())
         FPeriod =as.integer(var_check_bu_FPeriod())
         FBrand = var_check_bu_FBrand()
         FChannel = var_check_bu_FChannel()
         data = jlrdspkg::check_rptBrandChannel(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel)
         print(data)
         
         run_dataTable2('check_bu_dataShow',data=data)
         run_download_xlsx(id = 'check_bu_dl',data = data,filename = '管报所有级次.xlsx')
         
         
       })
       #针对相关内容进行片
       var_div_FYear <- var_text('div_FYear')
       var_div_FPeriod <-var_text('div_FPeriod')
       var_div_rptItemName <- var_ListChoose1('div_rptItemName')
       var_div_digit <- var_integer('div_digit')
       var_div_calcType <- var_ListChoose1('div_calcType')
       
       observeEvent(input$div_btn,{
         FYear = as.integer(var_div_FYear())
         FPeriod =as.integer(var_div_FPeriod())
         FRptItemName = var_div_rptItemName()
         print(FRptItemName)
         digit = as.integer(var_div_digit())
         #增加计算类型
         FCalcType = var_div_calcType()
         data = jlrdspkg::div_diff_analysis(conn = conn,FYear = FYear,FPeriod = FPeriod,FRptItemName =FRptItemName,digit = digit,FCalcType = FCalcType)
         run_dataTable2('div_dataShow',data = data)
         run_download_xlsx(id = 'div_dl',data = data,filename = '事业部差异下载.xlsx')
         
         
         
         
         
       })
       
    
  
})
