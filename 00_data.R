# 设置app标题-----

app_title <-'JALA财务分析平台V1.2';


#change log
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





