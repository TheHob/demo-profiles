# This class installs NGINX
class profiles::nginx {

  # Install nginx
  include nginx

  # Ensure web root
  file { '/var/www':
    owner => root,
    group => root,
    mode  => '0755',
  }

}
