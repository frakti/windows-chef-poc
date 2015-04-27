override['sql_server']['accept_eula'] = true
override['sql_server']['product_key'] = nil
override['sql_server']['instance_name'] = 'SQLEXPRESS'
override['sql_server']['sysadmins'] = 'DatabaseAdmin'
override['sql_server']['server_sa_password'] = 'JaCierpieDole-1234'
# https://technet.microsoft.com/en-us/library/ms144259(v=sql.110).aspx#Feature
override['sql_server']['feature_list'] = 'SQLENGINE,REPLICATION,SNAC_SDK,SSMS' # ADV_SSMS
