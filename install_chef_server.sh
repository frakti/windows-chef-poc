CHEF_SERVER_RPM='chef-server-core-12.0.8-1.el6.x86_64.rpm'
OUTPUT_DIR=/vagrant

# It will fetch RPM to mounted dir (where Vagrantfile lives), so next time you build
# chef-server it won't fetch it again and reuse it.
wget -c -P $OUTPUT_DIR https://web-dl.packagecloud.io/chef/stable/packages/el/6/$CHEF_SERVER_RPM
rpm -Uvh $OUTPUT_DIR/$CHEF_SERVER_RPM

chef-server-ctl reconfigure
chef-server-ctl install opscode-manage
chef-server-ctl install opscode-push-jobs-server
chef-server-ctl install opscode-reporting
chef-server-ctl reconfigure
opscode-manage-ctl reconfigure
opscode-push-jobs-server-ctl reconfigure
opscode-reporting-ctl reconfigure

chef-server-ctl user-create frakti Tomasz Sikora dummy@account.com JaCierpieDole -f $OUTPUT_DIR/.chef/frakti.pem
chef-server-ctl org-create frakti Sandbox --association_user frakti -f $OUTPUT_DIR/.chef/frakti-validator.pem
