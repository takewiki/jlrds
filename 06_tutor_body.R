menu_tutor <- tabItem(tabName = "tutor",
                      fluidRow(
                        column(width = 12,
                               tabBox(title ="元数据管理工作台",width = 12,
                                      id='tabSet_tutor',height = '300px',
                                      tabPanel('数据源复盘',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tagList(
                                            h4('一、实际数据'),
                                            h4('二、执行预算'),
                                            h4('三、历史数据')
                                          )
                                         
                                          
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          
                                          tagList(
                                            h4('1.1、财务凭证:SAP凭证'),
                                            h4('1.2、业务报表：BW报表'),
                                            h4('1.3、调整分录:手调凭证、手调记录'),
                                            h4('1.4、补充资料1：经营快报-公司零售额、回款'),
                                            h4('1.5、补充资料2：集团中后台费用'),
                                            h4('二、执行预算'),
                                            h4('三、历史数据')
                                          )
                                        )
                                        ))
                                        
                                      )),
                                      tabPanel('主数据复盘',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tagList(
                                            h4('一、组织架构'),
                                            h4('二、成本中心'),
                                            h4('三、成本要素'),
                                            h4('四、报表项目'),
                                            h4('五、重分类代码')
                                          )
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tagList(
                                            h4('1.1、集团、事业部、品牌、渠道、子渠道'),
                                            h4('1.2、各层级汇报关系'),
                                           
                                            h4('2.1市场类成本中心'),
                                            h4('2.2渠道类成本中心:每个月可能存在新增'),
                                            h4('3.1、主要是费用类成本要素'),
                                            h4('3.2、营业外支出不考虑'),
                                            h4('四、报表项目'),
                                            h4('五、重分类代码'),
                                            h4('六、业务报表分析维度'),
                                            h4('七、业务报表分析指标')
                                          )
                                        )
                                        ))
                                        
                                      )),
                                      
                                      tabPanel('业务规则复盘',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tagList(
                                          
                                           
                                          
                                            h4('一、财务凭证取数规则'),
                                           
                                            h4('二、业务报表取数规则'),
                                            h4('三、手工调整取数规则'),
                                          )
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tagList(
                                            h4('1.1、组织架构各层级汇总关系'),
                                            h4('1.1.1、货架子渠道撤柜'),
                                            h4('1.1.2、KA小计、特通小计、大客户发展部小计'),
                                            h4('1.1.3、自然堂品牌、美素品牌...'),
                                            h4('1.2、渠道费用分配比例表'),
                                            h4('1.3、市场费用分配比例表'),
                                            h4('1.3.1、品牌市场费用费用归集'),
                                            h4('1.3.2、品牌营业成本费用归集'),
                                            h4('1.3.3、国际事业部不参与市场费用分配'),
                                            h4('1.3.4、已撤柜货架不参与市场费用分配'),
                                            h4('1.4、成本要素与报表项目对照表'),
                                            h4('1.4.1、集团统一成本要素与报表项目对照表'),
                                            h4('1.4.2、自然堂电商成本要素与报表项目对照表'),
                                            h4('1.4.3、珀芙研成本要素与报表项目对照表：费用冲收入'),
                                            h4('1.5、重分类代码应用规则'),
                                            h4('1.5.1、科目代码重分类:费用重分类'),
                                            h4('1.5.2、一盘货不计入：剔除费用金额'),
                                            h4('2.1、收入成本取数规则'),
                                            h4('2.2、个人取数规则:按品牌+成本中心'),
                                            h4('2.3、个人领料中成本中心的分配比例'),
                                            h4('3.1、手工调整的记账正负性问题')
                                          )
                                          
                                         
                                        )
                                        )
                                        ))
                                        
                                      ),
                                      tabPanel('计算过程表',tagList(
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
                                      tabPanel('管报结果表',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tagList(
                                            h4('管报结果表元数据管理')
                                          )
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tagList(
                                            h4('管理结果-所有级次写入HANA前:mrpt3_vw_FI_RPA')
                                          )
                                        )
                                        ))
                                        
                                      )),
                                      tabPanel('管报反查表',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tagList(
                                            h4('管报反查表元数据管理')
                                            
                                          )
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tagList(
                                            h4('事业部级差异反查表:vw_mrpt_division_diff'),
                                            h4('反查表-品牌渠道:jlrdspkg::mrpt_res_review_brandChannel'),
                                            h5('反查表-品牌渠道-R:rds_vw_mrpt_TargetRpa_review'),
                                            h5('反查表-品牌渠道-SQL:t_mrpt_division'),
                                            br(),
                                            h4('管报反查表'),
                                            h5('管报反查表-R:mrptpkg::audit_fi_rpa_brandChannel'),
                                            h5('管报反查表-SQL:rds_vw_T_FI_RPA_brandChannel'),
                                            
                                          )
                                        )
                                        ))
                                        
                                      )),
                                      tabPanel('程序设计注意事项',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'sheet4'
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tagList(
                                            h4('增加日志记录的功能，日志分为过程日志detail及调试日志debug'),
                                            h4('增加成本中心拆分功能,支持按品牌+渠道维护成本中心,实现部分更新'),
                                            h4('增加BW规则按品牌渠道的拆分功能，实现版本更新'),
                                            h4('针对数据源、基础资料、规则实现版本化规则，按月设置版本号,分库分表进行处理'),
                                            h4('针对大量的数据，实现分页管理，这是避免数据库服务器卡死的有效途径'),
                                            h4('将除了品牌渠道的其他数据也纳入反查表功能,目前反查表功能还是做得非常成功的')
                                            
                                          )
                                        )
                                        ))
                                        
                                      )),
                               
                                      tabPanel('sheet8',tagList(
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
                                      tabPanel('sheet9',tagList(
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
