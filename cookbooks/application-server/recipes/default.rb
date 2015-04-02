windows_feature 'IIS-WebServerRole'
windows_feature 'IIS-WebServer'

file 'c:\inetpub\wwwroot\Default.htm' do
  content '<html>
  <body>
    <h1>Windows-based infrastructure PoC</h1>
  </body>
</html>'
end