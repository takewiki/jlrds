

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
    
    #2.8 BW报表业务规则----
    observeEvent(input$md_bw_businessRule_preview,{
      
      data <- jlrdspkg::mrpt_bw_ui_businessRule(conn = conn)
      print(data)
      ncount <- nrow(data)
      print('div')
      
      if (ncount >0){
        run_dataTable2(id = 'md_bw_businessRule_dataShow',data = data)
        run_download_xlsx(id = 'md_bw_businessRule_dl',data = data,filename = 'BW报表业务规则.xlsx')
      }else{
        pop_notice('没有查到数据，请检查参数！')
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
    
    
    
    
    
    

    
  
})
