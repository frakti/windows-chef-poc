name "sqlserver"
description "SQL Server 2012"
run_list "recipe[sqlserver]"
override_attributes({
  'sql_server' => {
    'version' => '2012'
  }
})
