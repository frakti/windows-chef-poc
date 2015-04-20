cache = Chef::Config[:file_cache_path]
version = node['website']['version']
websites_temp_path = "#{cache}\\websites"
application_path = "#{node['iis']['docroot']}\\staffcare\\poc"

iis_pool 'SimpleAppPool' do
  runtime_version '4.0'
  action [ :add, :stop ]
end

directory application_path do
  inherits true
  recursive true
end

iis_app 'Default Web Site' do
  path '/poc'
  application_pool 'SimpleAppPool'
  physical_path application_path
  enabled_protocols 'http,net.pipe'
  action :add
end

file "#{cache}\\websites.zip" do
  action :delete
end

windows_zipfile application_path do
  source "#{cache}\\websites.zip"
  overwrite true
  action :nothing
end

remote_file "#{cache}\\websites.zip" do
  rights :full_control, 'Everyone'
  source "#{node['artefact_repo_url']}/websites-#{version}.zip"

  notifies :stop,  'iis_pool[SimpleAppPool]', :immediately
  notifies :unzip, "windows_zipfile[#{application_path}]", :immediately
  notifies :start, 'iis_pool[SimpleAppPool]'
end