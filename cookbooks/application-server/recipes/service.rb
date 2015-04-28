cache = Chef::Config[:file_cache_path]
services_path = 'C:\source\services'
version = node['service']['version']

service_runner = 'ServiceRunner'
service_runner_pwd = 'JaCierpieDole1234'

user service_runner do
  password service_runner_pwd
end

group 'Administrators' do
  action :modify
  members service_runner
  append true
end

windows_zipfile services_path do
  source "#{cache}\\services.zip"
  overwrite true
  action :nothing
end

exe_path = "#{services_path}\\Poc.Deploy.WriteWinService.exe"

windows_package 'Install-EmploymentWcfService' do
  installer_type :custom
  options "install -username:.\\#{service_runner} -password:#{service_runner_pwd} start"
  source exe_path
  timeout 15
  only_if { File.exists?(exe_path) }
  action :nothing
end

windows_package 'Uninstall-EmploymentWcfService' do
  ignore_failure true
  installer_type :custom
  options 'uninstall'
  source exe_path
  timeout 15
  only_if { File.exists?(exe_path) }
  action :nothing
end

file "#{cache}\\services.zip" do
  action :delete
end

remote_file "#{cache}\\services.zip" do
  rights :full_control, 'Everyone'
  source "#{node['artefact_repo_url']}/services-#{version}.zip"

  notifies :install,  "windows_package[Uninstall-EmploymentWcfService]", :immediately
  notifies :unzip,    "windows_zipfile[#{services_path}]", :immediately
  notifies :install,  "windows_package[Install-EmploymentWcfService]", :immediately
  notifies :start,    "service[Poc.Deploy.WriteWinServiceHost]"
end

# db_host = search(:node, "role:sqlserver")['ipaddress']

template "#{services_path}\\App.connections.config" do
  source 'App.connections.config.erb'
  variables({
    :db_host => '10.0.1.14',
    :db_user => 'sa',
    :db_pass => 'JaCierpieDole-1234'
    })
  notifies :restart,  "service[Poc.Deploy.WriteWinServiceHost]"
end

service 'Poc.Deploy.WriteWinServiceHost'
