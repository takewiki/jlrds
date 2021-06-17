# 设置app标题-----

 app_title <-'JALA财务分析平台V3.0';
#app_title <-'棱星RDS-资金日报数据处理系统V1.0';
 



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





