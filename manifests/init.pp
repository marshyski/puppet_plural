class puppet_plural (
  $repo_url     = 'http://yum.marshyski.com',
  $elastic_host = 'plural.marshyski.com',
  $elastic_port = '9200',
  $environment  = 'dev',
  ) {

  #puppet module install ajcrowe-supervisord
  include ::supervisord

  yumrepo { 'plural-beta':
    ensure   => 'present',
    baseurl  => $repo_url,
    descr    => 'Plural Beta',
    enabled  => '1',
    gpgcheck => '0',
  }

  package { 'plural':
    ensure  => latest,
    require => Yumrepo['plural-beta'],
  }

  file { /opt/plural/bin/plural:
    ensure  => present,
    mode    => '0755',
    require => Package['plural'],
  }

  file { '/opt/plural/conf/plural.yaml':
    ensure  => present,
    content => template('puppet_plural/plural.yaml'),
    require => Package['plural'],
  }

  supervisord::program { 'plural':
    command     => '/opt/plural/bin/plural',
    user        => 'root',
    priority    => '1',
    autostart   => 'yes',
    autorestart => 'true',
    require     => File['/opt/plural/conf/plural.yaml'],
  }
}
