

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
    observeEvent(input$md_bw_businessRule_preview,{
      
      #data <- jlrdspkg::mrpt_bw_ui_businessRule(conn = conn)
      #第一版做了升级
      data <- jlrdspkg::mrpt_md_rule_bw2_select(conn = conn)
      # print(data)
      ncount <- nrow(data)
      print('div')
      
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
        file_name = var_md_bw_businessRule_file()
        if(is.null(file_name)){
          pop_notice('请选择一个文件')
        }else{
          jlrdspkg::mrpt_md_rule_bw2_read(conn = conn,file_name = file_name)
          pop_notice('上传BW报表业务规则成功')
        }
        
        
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
    #凭证分析-----
    var_voucher_audit_beforeReclass_Year <- var_text('voucher_audit_beforeReclass_Year')
    var_voucher_audit_beforeReclass_Period <- var_integer('voucher_audit_beforeReclass_Period')
    
    
    data_voucher_before_summary <- eventReactive(input$voucher_audit_beforeReclass_btn,{
      FYear =  as.integer(var_voucher_audit_beforeReclass_Year())
      FPeriod =  as.integer( var_voucher_audit_beforeReclass_Period())
      data_summary <- mrptpkg::voucher_beforeReClass_costItem_summary(conn = conn,FYear = FYear,FPeriod = FPeriod)
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
      FCostItemNumber <- data_summary[as.integer(input$voucher_beforeReClass_summary_dt_rows_selected), 'FCostItemNumber']
      data_detail1 <- mrptpkg::voucher_beforeReClass_costItem_detail_costCenterNo(conn = conn,FYear = FYear,FPeriod = FPeriod,FCostItemNumber = FCostItemNumber)
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
      FCostItemNumber <- drilldata1()[as.integer(input$voucher_beforeReClass_detail_dt1_rows_selected), 'FCostItemNumber']
      print(FCostItemNumber)
      FCostCenterNo <- drilldata1()[as.integer(input$voucher_beforeReClass_detail_dt1_rows_selected), 'FCostCenterNo']
      print(FCostCenterNo)
      data_detail2 <- mrptpkg::voucher_beforeReClass_costItem_detail_list(conn = conn,FYear = FYear,FPeriod = FPeriod,FCostItemNumber = FCostItemNumber,FCostCenterNo = FCostCenterNo)
      return(data_detail2)
      
    })
    
    #print(drilldata2())
    
    output$voucher_beforeReClass_detail_dt2 <- DT::renderDataTable(drilldata2(),selection = 'single')
    
    
  
})
