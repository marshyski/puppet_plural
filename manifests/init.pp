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

  yumrepo { 'epel':
    ensure         => 'present',
    descr          => 'Extra Packages for Enterprise Linux 6 - $basearch',
    enabled        => '1',
    failovermethod => 'priority',
    gpgcheck       => '0',
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
    mirrorlist     => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch',
  }

  package {
    [
    'supervisor',
    'plural',
    ]:
      ensure  => latest,
      require => [Yumrepo['epel'], Yumrepo['plural-beta']],
  }

  file { '/opt/plural/bin/plural':
    ensure  => present,
    mode    => '0755',
    require => Package['plural'],
  }

  file { '/opt/plural/conf/plural.yaml':
    ensure  => present,
    content => template('puppet_plural/plural.yaml'),
    require => Package['plural'],
  }

  file { '/etc/supervisord.conf':
    ensure  => present,
    content => template('puppet_plural/supervisord.conf'),
    require => Package['supervisor'],
  }

  service { 'supervisord':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => File['/etc/supervisord.conf'],
    require    => [File['/opt/plural/conf/plural.yaml'], File['/etc/supervisord.conf']],
  }

}
