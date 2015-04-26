servers = [
 { id: :lb,   ip: "10.0.1.10", hostname: "lb",        role: 'lb',         vcpu: 1, ram: 1024 },
 { id: :iis1, ip: "10.0.1.11", hostname: "iis1",      role: 'app_server', vcpu: 2, ram: 1024 },
 { id: :iis2, ip: "10.0.1.12", hostname: "iis2",      role: 'app_server', vcpu: 1, ram: 1024 },
 { id: :sql,  ip: "10.0.1.14", hostname: "sqlserver", role: 'sqlserver',  vcpu: 1, ram: 1024 }
]
chef_server_ip = '10.0.1.8'


Vagrant.configure(2) do |config|

  servers.each do |server_settings|
    config.vm.define server_settings[:id] do |server|
      server.vm.box = "win"
      server.vm.guest = :windows
      server.vm.communicator = :winrm

      server.vm.provider "virtualbox" do |v|
        v.name    = "#{server_settings[:ip]} - #{server_settings[:hostname]}"
        v.memory  = server_settings[:ram]
        v.cpus    = server_settings[:vcpu]
        v.customize [ "modifyvm", :id, "--cpuexecutioncap", "90" ]
      end

      server.vm.network :private_network, ip: server_settings[:ip]
      server.vm.hostname = server_settings[:hostname]

      config.vm.provision "chef_client" do |chef|
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

    # Chef-server

    config.vm.define :chef, autostart: false do |server|
      server.vm.box = "chef/centos-6.6"

      server.vm.network "private_network", ip: chef_server_ip
      server.vm.hostname = "chef-server"

      server.vm.provider :virtualbox do |vb|
        vb.name    = "#{chef_server_ip} - Chef Server"
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end

      config.vm.provision "shell", path: 'install_chef_server.sh'
      config.vm.provision "shell", path: 'configure_artefacts_repo.sh'
    end
  end

end
