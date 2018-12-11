class profile::site::blog (
	$port = hiera('profile::site::blog::port'),
	$url = hiera('profile::site::blog::url'),
	$docroot = hiera('profile::site::blog::docroot'),
) {

  include '::mysql::server'

  class { 'mysql::bindings': 
	php_enable => 'true',
  }

  class { 'apache':
	mpm_module => 'prefork',
  }

  class { 'apache::mod::php':
	package_name => 'libapache2-mod-php7.2',
	path => '/usr/lib/apache2/modules/libphp7.2.so',
  } 

  class { '::php::globals':
	php_version => '7.2',
  }

  package { 'php7.2-mysql':
	ensure => 'present',
 }

  apache::vhost { $url:
	port => $port,
	docroot => $docroot,
  }
	
  class { 'wordpress':
	version => '4.9.8',
        db_user => 'wordpress2',
	db_name => 'wordpress2',
	install_dir => $docroot,
  }

}	

  class role::site::blog {
	include profile::site::blog
  }
