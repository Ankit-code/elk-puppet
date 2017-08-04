class filebeat {

#	exec { 'copy ssl cert':
#	command => '/usr/bin/scp root@master:/etc/pki/tls/certs/logstash-forwarder.crt /etc/pki/tls/certs/',
#	}

	exec { 'import elasticsearch key':
                command => '/usr/bin/rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch',
        }

	file { 'filebeat repo':
		ensure => file,
		path => '/etc/yum.repos.d/filebeat.repo',
		content => file('filebeat/filebeat.repo'),
	}
	file { 'filebeat certificate':
                ensure => file,
                path => '/etc/pki/tls/certs/logstash-forwarder.crt',
                content => file('filebeat/logstash-forwarder.crt'),
        }

	file { 'logstash-key':
		ensure => file,
		path   => '/etc/pki/tls/private/logstash-forwarder.key',
		content=> file('filebeat/logstash-forwarder.key'),
	}

	package { 'filebeat':
		provider => 'yum',
		ensure   => 'installed',
		require  => File['filebeat repo'],
	}

	service { 'filebeat':
		ensure => running,
		enable => true,
		require=> [
			Package['filebeat'],
			File['filebeat repo'],
			File['filebeat yaml'],
		]
	}

	file { 'filebeat yaml':
		ensure => file,
		path   => '/etc/filebeat/filebeat.yml',
		content=> file('filebeat/filebeat.yml'),
	}

} 
