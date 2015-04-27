user 'DatabaseAdmin' do
  uid 1234
  password 'JaCierpieDole1234'
end

group 'Administrators' do
  action :modify
  members 'DatabaseAdmin'
  append true
end

include_recipe 'sql_server::server'

# Configuring remote access
# https://msdn.microsoft.com/en-us/library/hh882461.aspx#bkmk_configureremoteaccess

windows_firewall_rule 'SQL Server 2012' do
  localport '1433'
  protocol :TCP
  description 'SQL Server 2012 listening port'
  service 'MSSQL$SQLEXPRESS'
  firewall_action :allow
end

service 'SQLBrowser' do
  action [ :enable, :start ]
end

powershell_script "Allow remote access to SQL Server" do
  code <<-EOH
    Import-Module SqlPs
    Invoke-Sqlcmd -Query "EXEC sys.sp_configure N'remote access', N'1';"
    Invoke-Sqlcmd -Query "RECONFIGURE WITH OVERRIDE;"
  EOH
end

# FIXME Temporary solution for some reason adding firewall rule above doesn't work.
# Adding it even manually doesn't work either. Disabling whole firewall fixes the issue.
# There is another Windows-specific one.
powershell_script "Reload firewall" do
  code <<-EOH
    Set-NetFirewallProfile -All -Enabled False
  EOH
end
