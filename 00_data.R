# 设置app标题-----

 app_title <-'JALA财务分析平台V5.20';
#app_title <-'棱星RDS-资金日报数据处理系统V1.0';
 
 
#5.17 to do list
# 增加同步最近一期功能
#  增加上传经营快报功能
#  完善计算功能
#  优化计算逻辑
 


# 添加对品牌与渠道的正式定义
# 品牌代码及品牌名称
# 渠道代码及渠道名称
# 定义子渠道
# 定义虚拟的渠道,其实是指两个小计部分,用于大客户部
# 定义角色，按角色设置数据权限,每个财务经理只能查看自己负责的渠道内容
# 已经定义了用户的角色，还没有定义用户负责的渠道
# 定义基础资料自动同步功能
# 针对BW规则进行优化,包括多月内容，增加描述部分
# 针对成本中心进行重新定义，包括SAP成本中心及BW成本中心
# 针对BW报表中的成本中心进行标准化，取消之前的公司代码如1000/
# 增加集团的财务报表，增加中后台费用
# 增加手工上传管报内容
# 支持使用手工管理取代替RAP计算内容
#change log
#3.0
#增加管报自动化，用于呈现RPA相关内容
#2.0
#完善自有资金完成
#1.6
#处理周报异常问题
#1.5
# add the own rpt


#1.3
# 增加万元处理
# 增加月份排序
# 增加周报与月报的更新
#1.2
# add the scroll box 
#1.0
#add the jala daily query


# store data into rdbe in the rds database
app_id <- 'jlrds'

#设置数据库链接---

conn_be <- conn_rds('rdbe')



#设置链接---
conn <- conn_rds('jlrds')

#报表相关数据

jala_week_amtType <- jlrdspkg::week_getRptType(conn = conn)

jala_month_amtType <- jlrdspkg::month_getRptType(conn = conn)

current_year <- function() {
  return(as.numeric(tsdo::left(as.character(Sys.Date()),4)))
  
}





