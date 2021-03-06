The chef-repo for Windows-based infrastructure PoC
===================================================
The aim of this Proof of Concept project is to see how [Chef](https://www.chef.io/solutions/windows/) deals with provisioning Windows-specific environment in typical app Use Case. And then scale it.
- *AS a user I WANT to increase employer salary AND persist it into database*
- *AS a returning user I WANT to see current salary value fetched from redis cache*

If you're wondering why the heck I'm using locally chef-server when I could go with chef-zero instead, it is because I would like to play with environment more closer to production and play around with this in isolated environment.

Architecture
------------
- *load balancer*
  * Application Request Routing
- *application servers*
  * WCF Service as managed Windows Service
  * ASP.NET MVC Web App
  * Redis
- *sqlserver* - SQL Server 2012 Express

![PoC Infrastructure](infrastructure.png)

Pre-requisites
--------------
- [Chef Development Kit](https://downloads.chef.io/chef-dk/)
- [Vagrant](https://www.vagrantup.com/) to orchestrate VMs
- [VirtualBox](https://www.virtualbox.org/)
- [Packer](https://packer.io/) (unless you have already Windows box for vagrant)
- More than 8GiB of RAM for VMs for smooth work (but you can decrease it in *Vagrantfile*)

Steps to setup environment
--------------------------

### Prepare Windows Server 2012 box

This is one time operation. To simplify it I recommend to use existing Packer template from [joefitzgerald/packer-windows](https://github.com/joefitzgerald/packer-windows). Clone the repo and run: `packer build windows_2012_r2.json`. After it's finished in the same dir you will get `windows_2012_r2_virtualbox.box` which can be imported to Vagrant using `vagrant box add win_server_2012 windows_2012_r2_virtualbox.box`.

*If you need different Widndows-based distributions check closer that repo.*

That template uses in the hood OpenSSH to prepare box. If this doesn't fit to your requirements you can:
- go with **@joefitzgerald** recommendation and uninstall OpenSSH (check README on [packer-windows](https://github.com/joefitzgerald/packer-windows))
- or try to combine that template with [packer-community/packer-windows-plugins](https://github.com/packer-community/packer-windows-plugins)

*FTR Chef itself is using WinRM, as well as vagrant though prepared Vagrantfile*

### Build Chef Server

Steps below will build and configure Chef Sever 12 and artefacts repository.
Scripts are using installation of version 12.0.8, if you want to use different one change `install_chef_server.sh` before proceed further.

1. Build chef-server using `vagrant up chef` (this will take a while). *Please note:* while provisioning script downloads RPM package (~470MiB) which is stored next to Vagrantfile, so there is no need re-downloading the package when you destroy and build VM again.
2. Run `knife ssl fetch` to download private cert from chef-server. Verify if it works fine by running `knife ssl check` and `knife client list`
4. You can sign in on https://10.0.1.8/ with credentials: *frakti* / *JaCierpieDole*
5. Artefacts repository is available under http://10.0.1.8:23000/ and points to `artefacts` dir

### Build application infrastructure

- run `./upload.sh` (OS-independent script)
- Create SQL Server instance by running `vagrant up sql` (issue #1 and #2)
- Create Load Balancer instance by run `vagrant up lb`
- Create Application Server instances by running `vagrant up iis1 iis2` (issue #1)

Unfortunately there are still idempotency (**Windows-specific**) issues, and few nodes won't be provisioned completely at first run. For more details check **Issues** below.

Application will be available under http://10.0.1.10/poc/
- *iis1* app is working on http://10.0.1.11/poc/
- *iis2* app is working on http://10.0.1.12/poc/

The app as well as static page on root (http://10.0.1.10/) show response origin to visualize working load balancing.

#### Issues

**#1** When adding new user to Administrators group, provisioning fails at fist time with an error:

> No mapping between account names and security IDs was done.

Temporary what you need to do is invoke `vagrant reload <node_name> --provision`

**#2** While provisioning SQL Server you will get an error:

> The specified module 'SqlPs' was not loaded because no valid module file was found in any module directory.

Solution for this is to run *provisioning* again: `vagrant provision sql`.

TODOs
-----
- Fix idempotentcy issues (#1 and #2)
- Write some tests.
- Use Chef Search instead of hardcoded IP in db connection string.
- Disable maintenance mode on VMs while provisioning - it slows down machine performance.

Contributors
------------
A big thanks to [@MSledzinski](https://github.com/MSledzinski) who prepared artefacts for this PoC ([MSledzinski/deploy-poc](https://github.com/MSledzinski/deploy-poc)).

Feel free to sent pull requests.
