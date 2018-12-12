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
        $column1,
        $type_column1,
        $column2,
        $type_column2,
) {

        class { 'postgresql::server':
        }

        postgresql::server::db { $db1:
                user     => $user1,
                password => postgresql_password($user1, $passwd1),
        }

        postgresql::server::db { $db2:
                user     => $user2,
                password => postgresql_password($user2, $passwd2),
        }

        postgresql::server::role { $role1:
                password_hash => postgresql_password($role1, $rolepw1),
       		createdb      => true,
		createrole    => true,
        }

        postgresql::server::database_grant { $db1:
                privilege => 'ALL',
                db        => $db1,
                role      => $role1,
        }

        postgresql::server::database_grant { $db2:
                privilege => 'CONNECT',
                db        => $db2,
                role      => $role1,
        }

        exec { 'create table $table1':
                command => "/bin/su - postgres -c '/usr/bin/psql $db2 -c \"CREATE TABLE $table1 ($column1 $type_column1, $column2 $type_column2);\"'",
                unless  => "/bin/su - postgres -c '/usr/bin/psql $db2 -c \"SELECT * from $table1;\"'",
        } -> 

        postgresql::server::table_grant { '$table1 of $db2':
                privilege => 'SELECT',
                table     => $table1,
                db        => $db2,
                role      => $role1,
        }

}
