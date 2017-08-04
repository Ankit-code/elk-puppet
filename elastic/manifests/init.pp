class elastic {
	package { 'java-1.8.0-openjdk':
		provider => 'yum',
		ensure   => 'installed',
	}

	exec { 'import elasticsearch key':
	   	 command => '/usr/bin/rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch',
	}
	
	file { 'elasticsearch repo':
                 ensure  => file,
                 path    => '/etc/yum.repos.d/elasticsearch.repo',
                 content => file('elastic/elasticsearch.repo'),
        }

	package { 'elasticsearch':
		provider => 'yum',
		ensure   => 'installed',
		subscribe=> File['elasticsearch repo'],
	}

	file { 'elastic init':
		ensure => file,
		path   => '/etc/init.d/elasticsearch',

	}

#	file { 'elastic yaml':
#		ensure => file,
#		path   => '/etc/elasticsearch/elasticsearch.yml',
#	}

	 service { 'elasticsearch':
                ensure => running,
                enable => true,
		hasstatus=>true,
		hasrestart=>true,
                require=> [
			Package['java-1.8.0-openjdk'],
			Package['elasticsearch'],
                        File['elastic init'],
                ]
        }
 	
} 
