# puppet_plural
Puppet module for Plural - Linux Inventory https://github.com/marshyski/plural

**No Install Dependencies**


**Parameters / Variables:**

     $repo_url     = 'http://yum.marshyski.com',
     $elastic_host = '104.236.20.133',
     $elastic_port = '9200',
     $environment  = 'dev',
     $interval     = '300',
     $username     = undef,
     $password     = undef,
     $package_ver  = 'latest',

**Tested:**
- RHEL / CentOS 6
- Puppet Enterprise 3.7/3.8
