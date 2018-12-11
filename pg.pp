class profile::site::postgres {

	class { 'postgresql::server':
		}

	postgresql::server::db {'dbno1':
		user 	 => 'dbuser1',
		password => postgresql_password('dbuser1','passwd1'),
	}

	postgresql::server::db {'dbno2':
                user     => 'dbuser1',
                password => postgresql_password('dbuser1','passwd1'),
        }

	postgresql::server::role { 'cho1':
		password_hash => postgresql_password('cho1','mypasswd123'),
	}

	postgresql::server::database_grant {'dbno1':
		privilege => 'ALL',
		db	  => 'dbno1',
		role	  => 'cho1',
	}

	postgresql::server::database_grant {'dbno2':
                privilege => 'CONNECT',
                db        => 'dbno2',
                role      => 'cho1',
        }

	postgresql::server::table_grant {'table1 of dbno2':
		privilege => 'ALL',
		table     => 'table1',
		db        => 'dbno2',
		role      => 'cho1'
	}

}
