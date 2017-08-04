class httpd{

file { '/etc/httpd/conf/httpd.conf':
	ensure => present,
	owner => 'root',
	group => 'root',
	mode  => '0644',
	require => Package["httpd"],
	notify => Service['httpd'],
}

package { 'httpd':
	provider => 'yum',
	ensure => present,
	before => File['/etc/httpd/conf/httpd.conf'],
}

service {'httpd':
	ensure => running,
	enable => true,
	require => [
		Package['httpd'],
		File['/etc/httpd/conf/httpd.conf'],
	]
}

}
