# Puppet Master and Jenkins

## Overview
This is single repository that will allow you to 'vagrant up' a Jenkins environment managed by a Puppet master running Puppet Enterprise.
Internet access is required for this environment.  Thanks to Terrimonster for her puppet-control repository as the starting point for this
project, https://github.com/terrimonster/puppet-control.

## Files/Directories

### Vagrantfile

Dictates basics of how Vagrant will spin up VM. Please do not edit this file unless you know what you are doing.

### Puppetfile
r10k needs this file to figure out what component modules you want from the Forge.

### environment.conf
Controls puppet's directory environment settings.

### hieradata
Contains your hiera data files.

### manifests
Contains site.pp

### site
Contains your organization-specific roles and profiles (wrappers for Forge component modules)

### hooks/
Git hooks for checking your Puppet code. There is a pre-commit you can copy to your .git/hooks repo directory. There is also a pre-receive for your git server (you also need to copy the commit_hooks subdirectory to your git server). You must install puppet and puppet-lint (locally for pre-commit, on the git server for pre-receive) to use these hooks.

To use the pre-receive hook on your Git server, copy the hook and the commit_hooks directory to the puppet-control.git directory in your repositories directory.

### provision/

Contains the script and files that are used to spin up the Vagrant VM. This is different from the Vagrantfile in that these are more specific to what you want to happen with the specific instance. The pe/ directory contains answer files, and, after you spin up PE for the first time, will contain PE installation media, which are in .gitignore.

If you want to avoid having to wait for PE to download during the provisioning process and you have the Puppet Enterprise tarball lying around, just copy it over to provision/pe and that step will be skipped.

### reference/
Reference materials for Puppet workflow.

### vagrant.yml

Gives instructions to Vagrantfile regarding what Vagrant box you want to use, and what virtual machines are available for provisioning, and what their options should be.

## How to use it

There are three systems in this environment:

| Name    | Description                  | Address        | App URL                                                  |
| ------- | ---------------------------- | -------------- | -------------------------------------------------------- |
| xmaster | The PE Master                | 192.168.137.10 | [https://192.168.137.10](https://192.168.137.10)         |
| jenkins  | Jenkins master running puppet agent | 192.168.137.14 |  [https://192.168.137.14:8080](https://192.168.137.14:8080) |
| node | Jenkins node running puppet agent | 192.168.137.15 |

The default credentials for the PE Master Console are:
* Username: `admin@example.com`
* Password: `password`

### Summary of procedure

1. Bring up instances
2. Push local control repository to Git server
3. Experiment

**Bring up all the nodes in the Vagrant environment:**

```
vagrant up
```

This will take some time to provision.

Ensure that the PE master is up and provisioned before attempting to start
another system.

Stuff included:

* Puppet Environments (control repository)
* Roles and Profiles
* Hiera
* Git/VCS workflow
* Optionally, [hiera-eyaml](https://github.com/TomPoulton/hiera-eyaml)
* [r10k](https://github.com/adrienthebo/r10k)
* [trlinkin/noop](https://github.com/trlinkin/trlinkin-noop)

Once everything is provisioned as you need it, you can ssh into the instance:

```
vagrant ssh xmaster
```

You will be logged in as user vagrant. Please sudo to root if you need to run puppet.


### 1. Install Puppet

Although really you should have it installed on your local machine already.

### 2. Install puppet-lint

```
gem install puppet-lint
```

### 3. Install Virtualbox

This vagrant setup requires one of the following versions: 4.0, 4.1, 4.2. The latest Virtualbox version is 4.3

### 4. Install Vagrant

Latest version, 1.7 when this repo was created, will work fine.


### Provisioning Summary

The Vagrant provisioning will install Puppet Enterprise with the appropriate
configuration for each system.  The Puppet Master will be configured and manged
using Puppet - you can look at the `role::puppet::master` to see what's going
on.  Basically, Puppet is configured for environments, r10k is installed and
configured, and Hiera is installed and configured.  During provisioning, the
provided control repository is cloned to the PE master and a local `puppet apply`
is done for the role.


Classification for all nodes are done via the
environment-specific `site.pp` using hiera_include


## Other

This makes use of Greg Sarjeant's [data-driven-vagrantfile](https://github.com/gsarjeant/data-driven-vagrantfile)

No Vagrant plugins are required.
