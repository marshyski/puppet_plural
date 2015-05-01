class puppet_plural (
  $repo_url     = 'http://yum.marshyski.com',
  $elastic_host = 'plural.marshyski.com',
  $elastic_port = '9200',
  $environment  = 'dev',
  ) {

  package { 'plural':
    ensure  => latest,
    require => File['/etc/yum.repos.d/plural.repo'],
  }

  file { /opt/plural/bin/plural:
    ensure  => present,
    mode    => '0755',
    require => Package['plural'],
  }

  file { '/etc/yum.repos.d/plural.repo':
    ensure  => present,
    content => template('puppet_plural/plural.repo'),
  }

  file { '/opt/plural/conf/plural.yaml':
    ensure  => present,
    content => template('puppet_plural/plural.yaml'),
    require => Package['plural'],
  }
}
