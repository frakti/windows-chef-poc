redis_path = 'C:\Program Files\Redis'

service 'redis' do
  ignore_failure true
  action :stop
end

windows_package 'Install Redis' do
  source 'https://github.com/downloads/rgl/redis/redis-2.4.6-setup-64-bit.exe'
  not_if {  ::Dir.exists?(redis_path) && %x[ "#{redis_path}\\redis-cli.exe" --version ] =~ /2.4.6/i }
  action :install
end

service 'redis' do
  action :start
end
