class test {

	file { '/etc/motd':
		ensure => present,
		mode   => '0644',
		replace=> true,
		content=> "Host ${facts['hostname']}, running ${facts['os']['release']['full']}\n",
	}

}
