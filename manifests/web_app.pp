class profiles::web_app {
## This profile will do the following:
#  Install an nginx server that
#    a) Serves requests over port 80
#    b) Serves a page with the content of this repository: https://github.com/puppetlabs/exercise-webpage.
#    c) Runs on Cent0S 6.6 (not tested for other platforms).
#

  include firewall
  include profiles::nginx

  # Set the web root as a variable
  $www_root_var = '/var/www/fancywebapp.localhost'

  # Create vhosts - log to the same files
  nginx::resource::vhost { ['localhost', 'fancywebapp.localhost']:
    www_root    => $www_root_var,
    listen_port => '80',
    access_log  => '/var/log/nginx/fancywebapp.localhost_access.log',
    error_log   => '/var/log/nginx/fancywebapp.localhost_error.log',
  }

  # Ensure web root
  file { $www_root_var:
    owner => root,
    group => root,
    mode  => '0755',
  }

  # Ensure git for vcsrepo
  if ! defined ('git') {
      package { 'git':
          ensure => installed,
      }
  }

  # Ensure content
  vcsrepo { $www_root_var:
    ensure            => latest,
    owner             => root,
    group             => root,
    provider          => git,
    source            => 'https://10.32.174.235/root/my-app-repo.git',
    revision          => 'master',
    require           => [ Package['git'], File[$www_root_var]],
  }

  # Allow traffic on port 8000
  firewall { '001 Allow inbound HTTP (v4)':
    dport  => 80,
    proto  => tcp,
    action => accept,
  }

}
