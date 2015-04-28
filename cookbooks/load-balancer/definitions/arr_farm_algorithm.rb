# Enum must be one of WeightedRoundRobin, LeastRequests, LeastResponseTime, WeightedTotalTraffic, RequestHash
# More about those algorithms: https://technet.microsoft.com/en-us/library/dd443524(v=ws.10).aspx

define :arr_farm_algorithm,
  :algorithm => :LeastRequests do

    farm_name = params[:name]

    execute "#{node['appcmd']} set config -section:webFarms /\"[name='#{farm_name}'].applicationRequestRouting.loadBalancing.algorithm:#{params[:algorithm]}\" /commit:apphost"

end