class logstash {
	file { 'logstash repo':
		ensure => file,
		path   => '/etc/yum.repos.d/logstash.repo',
		content => file('logstash/logstash.repo'),
	}

	package { 'logstash':
		provider => 'yum',
		ensure   => installed,
	}

	file { 'openssl':
		ensure => file,
		path   => '/etc/pki/tls/openssl.cnf',
		content => template('logstash/openssl.cnf.erb'),
	}

#	 exec { 'generate certi':
#                command => '/usr/bin/cd /etc/pki/tls; openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt',
#        }

	file { 'logstash conf':
		ensure => file,
		path   => '/etc/logstash/conf.d/logstash.conf',
		content => file('logstash/logstash.conf'),
	}

	service { 'logstash':
		ensure => running,
		enable => true,
		hasstatus=>true,
		hasrestart=>true,
		require=> [
			File['logstash repo'],
			Package['logstash'],
			File['logstash conf'],
			]
	}

#	exec { 'logstash restart':
#		command => '/usr/bin/systemctl restart logstash',
#	}


}  
