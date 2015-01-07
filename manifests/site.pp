filebucket { 'main':
  server => $::servername,
  path   => false,
}

File { backup => 'main' }

Package {
  allow_virtual => true,
}

node 'xmaster.vagrant.vm' {
  include role::puppet::master
}

node 'jenkins.vagrant.vm' {
  include role::base

  class { 'jenkins':
    lts                 => true,
    configure_firewall  => false,
    plugin_hash         => {
      # git plugin required for jobs to utilize git repositories
      'git-client'                    => {},
      # git plugin required for jobs to utilize git repositories
      'git'                           => {},
      # jenkins enterprise
      'cloudbees-enterprise-plugins'  => {},
      'async-http-client'             => {},
      'credentials'                   => {},
      # compiler warnings
      'analysis-core'                 => {},
      'warnings'                      => {},
    }
  }

  include jenkins::master
}

node 'node.vagrant.vm' {
  class { 'jenkins::slave' :
    masterurl => 'https://jenkins.vagrant.vm:8080',
    #ui_user   =>
    #ui_pass   =>
  }
}

node default {
  ## Using hiera to classify our nodes
  hiera_include('classes')
}
