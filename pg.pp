class profile::site::postgres (
	$db1,
	$user1,
	$passwd1,
	$db2,
	$user2,
	$passwd2,
	$role1,
	$rolepw1,
	$table1,
) {

	class { 'postgresql::server':
	}

	postgresql::server::db { $db1:
		user 	 => $user1,
		password => postgresql_password($user1, $passwd1),
	}

	postgresql::server::db { $db2:
                user     => $user2,
                password => postgresql_password($user2, $passwd2),
        }

	postgresql::server::role { $role1:
		password_hash => postgresql_password($role1, $rolepw1),
	}

	postgresql::server::database_grant { $db1:
		privilege => 'ALL',
		db	  => $db1,
		role	  => $role1,
	}

	postgresql::server::database_grant { $db2:
                privilege => 'CONNECT',
                db        => $db2,
                role      => $role1,
        }

	postgresql::server::table_grant {'$table1 of $db2':
		privilege => 'ALL',
		table     => $table1,
		db        => $db2,
		role      => $role1,
	}

}
