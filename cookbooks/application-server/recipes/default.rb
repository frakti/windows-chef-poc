::Chef::Recipe.send(:include, Windows::Helper)

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

include_recipe 'application-server::service'
include_recipe 'application-server::website'