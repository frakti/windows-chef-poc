include_recipe 'sql_server::server'

windows_firewall_rule 'SqlServer2012' do
  localport '1433'
  protocol :TCP
  firewall_action :allow
end
