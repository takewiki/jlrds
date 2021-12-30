menu_tutor <- tabItem(tabName = "tutor",
                      fluidRow(
                        column(width = 12,
                               tabBox(title ="元数据管理工作台",width = 12,
                                      id='tabSet_tutor',height = '300px',
                                      #tab1-数据源------
                                      tabPanel('数据源',tagList(
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
                                            h5('SAP凭证(重分类前)-SQL:t_mrpt_data_sap'),
                                            h5('SAP凭证(重分类后)-SQL:t_mrpt_data_sap_withReClassified'),
                                          
                                            br(),
                                            hr(),
                                            
                                            h4('1.2、业务报表：BW报表'),
                                            h5('BW报表-SQL:mrpt2_t_ds_all'),
                                            h5('BW报表-已经不再使用的表结构如下'),
                                            br(),
                                            p('select * from vw_mrpt_ds_S001      
union all       
select * from vw_mrpt_ds_S002      
union all      
select * from vw_mrpt_ds_S003      
union all       
select * from vw_mrpt_ds_S004      
union all       
select * from vw_mrpt_ds_S005      
union all       
select * from vw_mrpt_ds_S006      
union all       
select * from vw_mrpt_ds_S007      
union all       
select * from vw_mrpt_ds_S008      
union all       
select * from vw_mrpt_ds_S009     
union all       
select * from vw_mrpt_ds_S010    
union all       
select * from vw_mrpt_ds_U001    '),
                                            br(),
                                            hr(),
                                            h4('1.3、调整分录:手调凭证、手调记录'),
                                            h5('t_mrpt_adj'),
                                            h5('mrpt2_vw_ds_adj_all'),
                                            h4('1.4、补充资料1：经营快报-公司零售额、回款'),
                                            h5('vw_mrpt_res_I02_RetailSales'),
                                            h5('vw_mrpt_res_I03_receive'),
                                            h4('1.5、补充资料2：集团中后台费用'),
                                            h5('mrpt2_vw_ds_mpv_manual'),
                                            h5('mrpt2_vw_ds_mpv_rpa'),
                                            h4('二、执行预算'),
                                            h5('t_mrpt_budget'),
                                            h4('三、历史数据'),
                                            h5('t_mrpt_actual'),
                                            h5('t_mrpt_actual_2019'),
                                            h5('t_mrpt_actual_2020')
                                          )
                                        )
                                        ))
                                        
                                      )),
                                      #tab2-主数据------------
                                      tabPanel('主数据',tagList(
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
                                            h5('模板：t_mrpt2_md_brandChannel'),
                                            h5('每月更新，已完成2021年：t_mrpt2_md_brandChannel_YearPeriod'),
                                           
                                            h4('2.1市场类成本中心'),
                                            h4('2.2渠道类成本中心:每个月可能存在新增'),
                                            h5('t_mrpt_costCenterRatio_sap'),
                                            br(),
                                            hr(),
                                            h4('3.1、主要是费用类成本要素'),
                                            h5('自然堂科目t_mrpt_chando_acctRptItem'),
                                            h4('3.2、营业外支出不考虑'),
                                            h4('四、报表项目'),
                                            h5('t_mrpt_rptItem'),
                                            br(),
                                            hr(),
                                            h4('五、重分类代码'),
                                            h5('五、重分类代码-SQL:t_mrpt_rule_sap_reClassified'),
                                            br(),
                                            hr(),
                                            h4('六、业务报表分析维度'),
                                            h4('七、业务报表分析指标')
                                          )
                                        )
                                        ))
                                        
                                      )),
                                      #tab3-业务规则-------
                                      tabPanel('业务规则',tagList(
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
                                            h5('BW规则表-SQL: t_mrpt_rule_bw2'),
                                            h5('BW规则表-R: mrpt_md_rule_bw2_dim_allocAll'),
                                            h5('BW规则表-R: mrpt_md_rule_bw2_dim_allocation'),
                                            h5('BW规则表-R: mrpt_md_rule_bw2_value_allocation'),
                                            h4('2.2、个人取数规则:按品牌+成本中心'),
                                            h4('2.3、个人领料中成本中心的分配比例'),
                                            h4('3.1、手工调整的记账正负性问题')
                                          )
                                          
                                         
                                        )
                                        )
                                        ))
                                        
                                      ),
                                      #tab4-计算过程表------
                                      tabPanel('计算过程表',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'sheet4'
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          h4('BW规则生效'),
                                          h5('BW规则生效-R:mrpt_md_rule_bw2_dim_allocAll'),
                                          h5('BW规则生效-R:mrpt_md_rule_bw2_dim_allocation'),
                                          h5('BW规则生效-R:mrpt_md_rule_bw2_value_allocation'),
                                          h6('t_mrpt_ds_bw_F13_itemGroupName_in'),
                                          h6('t_mrpt_ds_bw_F13_itemGroupName_Notin'),
                                          h6('t_mrpt_ds_bw_F14_brandName_in'),
                                          h6('t_mrpt_ds_bw_F14_brandName_Notin'),
                                          h6('t_mrpt_ds_bw_F30_customerNumber_in'),
                                          h6('t_mrpt_ds_bw_F30_customerNumber_Notin'),
                                          h6('t_mrpt_ds_bw_F33_subChannelName_in'),
                                          h6('t_mrpt_ds_bw_F33_subChannelName_Notin'),
                                          h6('t_mrpt_ds_bw_F37_disctrictSaleDeptName_in'),
                                          h6('t_mrpt_ds_bw_F37_disctrictSaleDeptName_Notin'),
                                          h6('t_mrpt_ds_bw_F41_channelName_in'),
                                          h6('t_mrpt_ds_bw_F41_channelName_Notin'),
                                          h6('t_mrpt_ds_bw_F61_costCenterControlNumber_in'),
                                          h6('t_mrpt_ds_bw_F61_costCenterControlNumber_Notin'),
                                         
                                          h6('t_mrpt_ds_bw_formula'),
                                          
                                          h5('Import规则表:t_mrpt_rule_bw2'),
                                          
                                          br(),
                                          hr(),
                                          h4('写入SAP数据-R：mrpt_write_sap'),
                                          h5('写入SAP数据-SQL：t_mrpt_data_sap'),
                                          h5('写入SAP数据-SQL:rds_t_mrpt_data_sap2'),
                                          h5('写入SAP数据-SQL:rds_t_mrpt_data_sap_withReClassified'),
                                          h5('数据源：SAP凭证：t_mrpt_data_sap_withReClassified'),
                                          h5('基础资料：重分类规则t_mrpt_rule_sap_reClassified'),
                                          br(),
                                          hr(),
                                          h4('写入BW数据-R：bw2_sync_data'),
                                          h5('写入BW数据-SQL:rds_t_mrpt_ds_bw_rpa_v'),
                                          h5('写入BW数据-SQL:vw_mrpt_ds_bw_rpa_v'),
                                          p('create view vw_mrpt_ds_bw_rpa_v as  
select * from vw_mrpt_ds_bw_rpa_M01  
union all  
select * from vw_mrpt_ds_bw_rpa_M02  
union all  
select * from vw_mrpt_ds_bw_rpa_M03  
union all  
select * from vw_mrpt_ds_bw_rpa_M04  
union all  
select * from vw_mrpt_ds_bw_rpa_M05  
union all  
select * from vw_mrpt_ds_bw_rpa_M06  
union all  
select * from vw_mrpt_ds_bw_rpa_M07  
union all  
select * from vw_mrpt_ds_bw_rpa_M08  
union all  
select * from vw_mrpt_ds_bw_rpa_M09  
union all  
select * from vw_mrpt_ds_bw_rpa_M10  
union all  
select * from vw_mrpt_ds_bw_rpa_M11  
union all  
select * from vw_mrpt_ds_bw_rpa_M12  
union all  
select * from vw_mrpt_ds_bw_rpa_M13  
union all  
select * from vw_mrpt_ds_bw_rpa_M14  
union all  
select * from vw_mrpt_ds_bw_rpa_M15'),
                                          h5('vw_mrpt_ds_bw_rpa'),
                                          h5('mrpt2_t_ds_all'),
                                          br(),
                                          hr(),
                                          h4('写入BW表核心算法'),
                                          h5('BW核心算法-R：bw2_deal_list'),
                                          h5('BW核心算法-R-删除历史数据:bw2_DeleteData'),
                                          h5('Export:BW核心算法-SQL(结果表):rds_t_mrpt_ds_bw_rpa_ruled'),
                                          h5('import(来源于上一步骤):rds_t_mrpt_ds_bw_rpa_v'),
                                          br(),
                                          hr(),
                                          h4('写入BW结果表'),
                                          h5('写入BW结果表-R:mrpt_write_bw2'),
                                          h5('Export:写入BW结果表-SQL:rds_t_mrpt_data_bw2'),
                                          h5('Import:rds_t_mrpt_ds_bw_rpa_ruled'),
                                          br(),
                                          hr(),
                                          h4('费用分配：mrpt_res_allocated'),
                                          h5('vw_mrpt_res_marketRatio'),
                                          h5('主营业务成本:vw_mrpt_res_cost'),
                                          h5('主营业务成本品牌小计：vw_mrpt_res_costTotal'),
                                          br(),
                                          hr(),
                                          h4('计算当期：mrpt_res_current'),
                                          h5('rds_t_mrpt_res_current_rpa'),
                                          tags$pre('
vw_mrpt_res_level_ALL4
	vw_mrpt_res_level_ALL3
		vw_mrpt_res_level_ALL2
			vw_mrpt_res_level_ALL_zero
			vw_mrpt_res_level_ALL_original
				vw_mrpt_res_level_ALL
					vw_mrpt_res_level12
						vw_mrpt_res_level1
							mrpt2_t_ds_all_Allocated
						vw_mrpt_res_I02_RetailSales
						vw_mrpt_res_I03_receive
			rds_vw_res_I06_profit
			rds_vw_res_I07_profitRate
			rds_vw_res_I08_salesFee
			rds_vw_res_I26_Salesprofit
			rds_vw_res_I27_marketFee
			rds_vw_res_I44_marketProfit
                                                   '),
                                        
                                         
                                          br(),
                                          hr(),
                                          
                                          
                                          
                                          
                                          
                                          
                                        )
                                        ))
                                        
                                      )),
                                      tabPanel('管报费用分配逻辑',tagList(
                                        fluidRow(
                                          column(12, box(
                                            title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            tags$pre('mrpt_res_allocated

mrpt2_t_ds_all_Allocated
mrpt2_vw_ds_all_Allocated

mrpt2_vw_ds_all_unAllocated_marketNot
   mrpt2_vw_ds_all_unAllocated
      mrpt2_vw_ds_sap_all
		mrpt2_vw_data_sap_rptItem_all_allocated
			mrpt2_vw_data_sap_rptItem_all_unique
				mrpt2_vw_data_sap_rptItem_all
					mrpt2_vw_data_sap_rptItem_GeneralOthers_notNull
						mrpt2_vw_data_sap_rptItem_GeneralOthers_all
							mrpt2_vw_data_sap_FeeName_generalOthers_notNull
								 mrpt2_vw_data_sap_FeeName_generalOthers_all  
									mrpt2_vw_data_sap_BrandChannel_GeneralOthers
										mrpt2_vw_data_sap_BrandChannel_notnull
											mrpt2_vw_data_sap_BrandChannel_all
												t_mrpt_data_sap
												mrpt2_vw_md_costCenter_total
													mrpt2_vw_md_costCenter_directFee
													mrpt2_vw_md_costCenter_marketFee
													mrpt2_vw_md_costCenter_salesFee_total 
										mrpt2_vw_data_sap_BrandChannel_biorrierYaoFang_other  
											mrpt2_vw_data_sap_BrandChannel_biorrierYaoFang
												mrpt2_vw_data_sap_BrandChannel_notnull
									t_mrpt_costItem_sap
							t_mrpt_rptItem
					mrpt2_vw_data_sap_rptItem_chandoEcom_notnull
						mrpt2_vw_data_sap_rptItem_chandoEcom_all  
							mrpt2_vw_data_sap_BrandChannel_chandoEcom
								mrpt2_vw_data_sap_BrandChannel_notnull
							t_mrpt_chando_acctRptItem
			mrpt2_vw_data_sap_salesFee_allocated
				mrpt2_vw_data_sap_rptItem_all_shared
					mrpt2_vw_data_sap_rptItem_all
				mrpt2_vw_md_costCenter_salesFee
					t_mrpt_costCenterRatio_sap
      mrpt2_vw_ds_bw_all 
		rds_t_mrpt_ds_bw_rpa_ruled
      mrpt2_vw_ds_adj_all
		t_mrpt_adj
vw_mrpt_res_MartetFee_toChannel
	mrpt2_vw_ds_all_unAllocated_market
		mrpt2_vw_ds_all_unAllocated 
			mrpt2_vw_ds_sap_all  
			mrpt2_vw_ds_bw_all 
			mrpt2_vw_ds_adj_all
		vw_mrpt_res_marketRatio
			vw_mrpt_res_cost
				mrpt2_vw_ds_all_unAllocated_withSuperCustomers_brandChannel  
					mrpt2_vw_ds_all_unAllocated_withSuperCustomers
						mrpt2_vw_ds_all_unAllocated
						mrpt2_vw_ds_all_kaTotal_detail
							mrpt2_vw_ds_all_ka_detail
								mrpt2_vw_ds_all_unAllocated
						mrpt2_vw_ds_all_TeTongTotal_detail
							mrpt2_vw_ds_all_TeTong_detail
								mrpt2_vw_ds_all_unAllocated
					t_mrpt2_md_brandChannel
			vw_mrpt_res_costTotal
				vw_mrpt_res_cost
mrpt2_vw_ds_all_kaTotal_detail
mrpt2_vw_ds_all_TeTongTotal_detail  
mrpt2_vw_ds_all_biorrierYaoFang_RevenueMinus
	mrpt2_vw_data_sap_BrandChannel_biorrierYaoFang_RevenueMinus
		mrpt2_vw_data_sap_BrandChannel_biorrierYaoFang
			mrpt2_vw_data_sap_BrandChannel_notnull
				mrpt2_vw_data_sap_BrandChannel_all 
					t_mrpt_data_sap
					mrpt2_vw_md_costCenter_total
						mrpt2_vw_md_costCenter_directFee
							t_mrpt_costCenterRatio_sap
						mrpt2_vw_md_costCenter_marketFee
							t_mrpt_costCenterRatio_sap
						mrpt2_vw_md_costCenter_salesFee_total 
                                                   ')
                                          )
                                          ))
                                        
                                      )),
                                      #tab5-管报结果表----------
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
                                      #tab6-反查表------
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
                                            br(),
                                            hr(),
                                            h4('管报反查-品牌选择'),
                                            h5('mrptpkg::audit_fi_rpa_brandChannel'),
                                            h5('rds_vw_T_FI_RPA_brandChannel'),
                                            br(),
                                            hr(),
                                            h4('管报反查-报表项目'),
                                            h5('mrptpkg::audit_fi_rpa_rpt'),
                                            h5('rds_vw_T_FI_RPA2'),
                                            br(),
                                            hr(),
                                            h4('管报过程表-SAP凭证'),
                                            h5('mrptpkg::audit_detail_fromDS1_SAP'),
                                            h5('mrpt2_vw_trace_sap_detail'),
                                            br(),
                                            hr(),
                                            h4('管报过程表-BW报表'),
                                            h5('mrptpkg::audit_detail_fromDS1_BW'),
                                            h5('mrpt2_vw_trace_bw_detail'),
                                            br(),
                                            hr(),
                                            h4('管报过程表-手调凭证'),
                                            h5('mrptpkg::audit_detail_fromDS1_ADJ'),
                                            h5('mrpt2_vw_trace_adj_detail')
                                            
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
                                        
                                      ))
                               
                                  ,
                                      tabPanel('市场费用分配注意点',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tags$pre("select * from vw_mrpt_res_cost
where FPeriod in(8,9,10)
and FBrand ='自然堂'


select * from 
mrpt2_vw_ds_all_unAllocated_market
where FPeriod in(8,9,10)
and FBrand ='自然堂'
")
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
