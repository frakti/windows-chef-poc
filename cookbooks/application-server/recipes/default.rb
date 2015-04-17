include_recipe 'application-server::redis'

include_recipe 'iis::mod_aspnet45'
include_recipe 'iis::mod_logging'
include_recipe 'iis::mod_tracing'

service 'w3svc' do
  action [:enable, :start]
end

file 'c:\inetpub\wwwroot\Default.htm' do
  content '<html>
  <body>
    <h1>Windows-based infrastructure PoC</h1>
  </body>
</html>'
end

application_path = "#{node['iis']['docroot']}\\simple\\poc"

iis_pool 'SimpleAppPool' do
  runtime_version '4.0'
  action [ :add, :stop ]
end

directory application_path do
  inherits true
  recursive true
end

iis_app 'Default Web Site' do
  path '/poc'
  application_pool 'SimpleAppPool'
  physical_path application_path
  enabled_protocols 'http,net.pipe'
  action :add
end