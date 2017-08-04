class kibana {

	file { 'kibana repo':
		ensure => file,
		path   => '/etc/yum.repos.d/kibana.repo',
		content => file('kibana/kibana.repo'),
	}

	package { 'kibana':
                provider => 'yum',
                ensure   => 'installed',
        }
	
#	exec { 'daemon reload':
#		command => '/usr/bin/systemctl daemon-reload',
#	}

	service { 'kibana':
		ensure => running,
		enable => true,
		require=> [
			Package['kibana'],
			File['kibana repo'],
		]
	}

}
