define :arr_server_weight,
  :weight => 100,
  :farm_name => nil do

    ip = params[:name]

    execute "#{node['appcmd']} set config -section:webFarms /\"[name='#{params[:farm_name]}'].[address='#{ip}'].applicationRequestRouting.weight:#{params[:weight]}\" /commit:apphost" do
      action :run
    end
end