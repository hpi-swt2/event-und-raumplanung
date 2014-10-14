# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty32"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box"
  
  # Configurate the virtual machine to use 2GB of RAM
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # port forward
  config.vm.network :forwarded_port, host: 3000, guest: 3000
  config.vm.synced_folder ".", "/home/vagrant/hpi-swt2" 

  # Use Chef Solo to provision our virtual machine
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]

    chef.add_recipe "apt"
    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::user"
    chef.add_recipe "rbenv::vagrant"
    chef.add_recipe "nano"
    chef.add_recipe "vim"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "postgresql::client"
    chef.add_recipe "postgresql::libpq"

    chef.json = {
      rbenv: {
        user_installs: [{
          user: 'vagrant',
          rubies: ["2.1.3"],
          global: "2.1.3",
          gems: {
            "2.1.3" => [
              { name: "bundler" }
            ]
          }
        }]
      },
      postgresql: {
        users: [
          {
            username: "vagrant",
            password: "",
            superuser: true,
            createdb: true,
            login: true
          },
        ],
       databases: [
          {
            name: "hpi_swt2_dev",
            owner: "vagrant",
            template: "template0",
            encoding: "UTF-8",
            locale: "en_US.UTF-8",
            extensions: "hstore"
          }
        ]
      },
      
    }
  end

end