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

# Install Redis

service 'redis' do
  ignore_failure true
  action :stop
end

redis_path = 'C:\Program Files\Redis'

windows_package 'Install Redis' do
  source 'https://github.com/downloads/rgl/redis/redis-2.4.6-setup-64-bit.exe'
  not_if {  ::Dir.exists?(redis_path) && %x[ "#{redis_path}\\redis-cli.exe" --version ] =~ /2.4.6/i }
  action :install
end

service 'redis' do
  action :start
end

# IIS

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