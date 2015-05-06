class puppet_plural (
  $repo_url     = 'http://yum.marshyski.com',
  $elastic_host = '104.236.20.133',
  $elastic_port = '9200',
  $environment  = 'dev',
  ) {

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

  service { 'plural':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    status     => '/sbin/service plural status | grep "is running"',
    subscribe  => File['/opt/plural/conf/plural.yaml'],
    require    => [File['/opt/plural/conf/plural.yaml'], File['/etc/init.d/plural']],
  }

  file { '/etc/init.d/plural':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['plural'],
  }

  file { '/opt/plural/bin/plural':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['plural'],
  }

  file { '/opt/plural/conf/plural.yaml':
    ensure  => present,
    content => template('puppet_plural/plural.yaml'),
    require => Package['plural'],
  }

}
