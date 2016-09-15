class profiles::jenkins {

  class {'jenkins':
    direct_download => false,
  }

}
