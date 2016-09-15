class profiles::jenkins {

  class {'jenkins':
    direct_download => false,
  }
# Retrospec  https://github.com/nwops/puppet-retrospec
}
