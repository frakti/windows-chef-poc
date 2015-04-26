servers = [
 { id: :lb,   ip: "10.0.1.10", hostname: "lb",        role: 'lb',         vcpu: 1, ram: 1024 },
 { id: :iis1, ip: "10.0.1.11", hostname: "iis1",      role: 'app_server', vcpu: 2, ram: 1024 },
 { id: :iis2, ip: "10.0.1.12", hostname: "iis2",      role: 'app_server', vcpu: 1, ram: 1024 },
 { id: :sql,  ip: "10.0.1.14", hostname: "sqlserver", role: 'sqlserver',  vcpu: 2, ram: 1536 }
]
chef_server_ip = '10.0.1.8'


Vagrant.configure(2) do |config|

  servers.each do |server_settings|
    config.vm.define server_settings[:id] do |server|
      server.vm.box = "win_server_2012"
      server.vm.guest = :windows
      server.vm.communicator = :winrm

      server.vm.provider "virtualbox" do |v|
        v.name    = "#{server_settings[:ip]} - #{server_settings[:hostname]}"
        v.memory  = server_settings[:ram]
        v.cpus    = server_settings[:vcpu]
        v.customize [ "modifyvm", :id, "--cpuexecutioncap", "90" ]
        v.customize [ "modifyvm", :id, "--nicpromisc2", "allow-all" ]
      end

      server.vm.network :private_network, ip: server_settings[:ip]
      server.vm.hostname = server_settings[:hostname]

      server.vm.provision "chef_client" do |chef|
      #  chef.log_level = :debug
        chef.chef_server_url = "https://#{chef_server_ip}/organizations/frakti"
        chef.validation_key_path = ".chef/frakti-validator.pem"
        chef.validation_client_name = "frakti-validator"
        chef.delete_node = true
        chef.delete_client = true
        chef.file_cache_path = 'c:/var/chef/cache'

        chef.add_role server_settings[:role]
      end
    end
  end

  # Chef-server

  config.vm.define :chef, autostart: false do |chef_server|
    chef_server.vm.box = "chef/centos-6.6"

    chef_server.vm.network "private_network", ip: chef_server_ip
    # Self-signed certs generated while installation are signed to domain being
    # a 'hostname' of the VM. Since our knife.rb points to chef-server via
    # IP the hostname must be the same to make SSL connection working.
    chef_server.vm.hostname = chef_server_ip

    chef_server.vm.provider :virtualbox do |vb|
      vb.name    = "#{chef_server_ip} - Chef Server"
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end

    chef_server.vm.provision "shell", path: 'install_chef_server.sh'
    chef_server.vm.provision "shell", path: 'configure_artefacts_repo.sh'
  end

end
