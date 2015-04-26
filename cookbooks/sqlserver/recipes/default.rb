user 'DatabaseAdmin' do
  uid 1234
  password 'JaCierpieDole1234'
end

group 'Administrators' do
  action :modify
  members "#{ENV['COMPUTERNAME']}\\DatabaseAdmin"
  append true
end

include_recipe 'sql_server::server'

windows_package node['sql_server']['ps_extensions']['package_name'] do
  source node['sql_server']['ps_extensions']['url']
  checksum node['sql_server']['ps_extensions']['checksum']
  installer_type :msi
  options "IACCEPTSQLNCLILICENSETERMS=#{node['sql_server']['accept_eula'] ? 'YES' : 'NO'}"
  action :install
end

# update path
windows_path 'C:\Program Files\Microsoft SQL Server\100\Tools\Binn' do
 action :add
end

windows_firewall_rule 'SQL Server 2012' do
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
