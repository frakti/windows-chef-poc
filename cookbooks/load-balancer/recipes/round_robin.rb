# TODO improve community cookbook iis_arr with support of load balancing algorithm
# Hint: checkout "appcmd.exe set config -section:webFarms -?" for available data to set

arr_farm_algorithm 'SimpleAppFarm' do
  algorithm 'WeightedRoundRobin'
end

arr_server_weight '10.0.1.11' do
  farm_name 'SimpleAppFarm'
  weight 100
end

arr_server_weight '10.0.1.12' do
  farm_name 'SimpleAppFarm'
  weight 100
end
