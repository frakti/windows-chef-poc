# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "frakti"
client_key               "#{current_dir}/frakti.pem"
validation_client_name   "frakti-validator"
validation_key           "#{current_dir}/frakti-validator.pem"
chef_server_url          "https://10.0.1.8/organizations/frakti"
cookbook_path            ["#{current_dir}/../cookbooks"]
