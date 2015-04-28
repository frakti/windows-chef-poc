include_recipe 'iis_arr::default'

iis_arr_server_farm 'SimpleAppFarm' do
  action :create
  servers [ '10.0.1.11', '10.0.1.12' ]
end

arr_farm_algorithm 'SimpleAppFarm' do
  algorithm 'LeastRequests'
end

iis_arr_server_farm 'StaticPageFarm' do
  action :create
  servers [ '10.0.1.11', '10.0.1.12' ]
end

include_recipe 'load-balancer::round_robin'

# http://www.iis.net/learn/extensions/configuring-application-request-routing-(arr)/define-and-configure-an-application-request-routing-server-farm
# To route all incoming HTTP requests to the server farm.
# This step is only required when creating the server farm using appcmd (used in the hood).
# When creating the server farm using the UI, the URL rewrite rules are created automatically.
# With appcmd, the URL rewrite rules must be created manually.
iis_arr_rewrite_rule "SimpleAppFarm_RouteAll" do
  pattern         '(.+)'
  pattern_syntax  'ECMAScript'
  url             'http://SimpleAppFarm/{R:0}'
  stop_processing true
end

iis_arr_rewrite_rule "StaticPageFarm_RouteAll" do
  pattern         '^$'
  pattern_syntax  'ECMAScript'
  url             'http://StaticPageFarm/'
  stop_processing true
end