include_recipe 'sql_server::server'

windows_firewall_rule 'SqlServer2012' do
  localport '1433'
  protocol :TCP
  firewall_action :allow
end

powershell_script "Allow remote access to SqlServer" do
  code <<-EOH
    Invoke-Sqlcmd -Query "EXEC sys.sp_configure N'remote access', N'1';"
    Invoke-Sqlcmd -Query "RECONFIGURE WITH OVERRIDE;"
  EOH
end

service 'SQLBrowser' do
  action [ :enable, :start ]
end
