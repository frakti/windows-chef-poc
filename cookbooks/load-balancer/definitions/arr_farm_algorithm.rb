# Enum must be one of WeightedRoundRobin, LeastRequests, LeastResponseTime, WeightedTotalTraffic, RequestHash

define :arr_farm_algorithm,
  :algorithm => :LeastRequests do

    farm_name = params[:name]

    execute "#{node['appcmd']} set config -section:webFarms /\"[name='#{farm_name}'].applicationRequestRouting.loadBalancing.algorithm:#{params[:algorithm]}\" /commit:apphost"

end