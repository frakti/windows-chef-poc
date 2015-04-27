service_runner = 'ServiceRunner'
service_runner_pwd = 'JaCierpieDole1234'

# WMF contains PowerShell 5.0 with DSC support
windows_package node['wmf']['name'] do
  source node['wmf']['url']
  checksum node['wmf']['checksum']
  timeout 300
  installer_type :custom
  options "/quiet /log"
  action :install
end

dsc_resource "User-Add-#{service_runner}" do
  resource :User
  property :UserName, service_runner
  property :FullName, service_runner
  property :Password, ps_credential(service_runner_pwd)
  property :PasswordChangeRequired, false
  property :PasswordNeverExpires, true
  property :Ensure, 'Present'
end

dsc_resource "Add-User-to-Administrators" do
  resource :Group
  property :GroupName, "Administrators"
  property :MembersToInclude, [ service_runner ]
end
