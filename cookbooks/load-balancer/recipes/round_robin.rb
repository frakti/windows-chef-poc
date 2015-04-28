# TODO improve community cookbook iis_arr with support of load balancing algorithm
# Hint 1: To get available properties  to change with expected format invoke:
#  C:\Windows\System32\inetsrv\appcmd.exe set config -section:webFarms -?
# Hint 2: To get current ARR config invoke:
#  C:\Windows\System32\inetsrv\appcmd.exe list config -section:webFarms

arr_farm_algorithm 'StaticPageFarm' do
  algorithm 'WeightedRoundRobin'
end

arr_server_weight '10.0.1.11' do
  farm_name 'StaticPageFarm'
  weight 100
end

arr_server_weight '10.0.1.12' do
  farm_name 'StaticPageFarm'
  weight 100
end

# Disabling cache by invalidating any static resource.
execute "#{node['appcmd']} set config -section:webFarms /\"[name='StaticPageFarm'].applicationRequestRouting.protocol.cache.validationInterval:00:00:00\" /commit:apphost" do
  action :run
end