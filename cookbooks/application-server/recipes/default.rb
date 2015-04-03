include_recipe 'iis::mod_aspnet45'

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