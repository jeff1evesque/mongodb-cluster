###
### Configures mongodb databases.
###

class mongodb_cluster::databases {
    include mongodb_cluster::install

    ## local variables
    $mongodb_node     = lookup('mongodb_node')
    $mongodb_database = lookup('database')
    $mongodb_cluster  = $mongodb_database['mongodb_cluster']
    $hiera_user       = $mongodb_cluster['user']
    $db_path          = $mongodb_cluster['db_path']
    $admin_user       = $hiera_user['admin']['name']
    $admin_password   = $hiera_user['admin']['password']

    mongodb_database { 'svm_dataset':
        ensure  => present,
        tries   => 10,
        require => [
            Package['mongodb-org-server'],
            Package['mongodb-org-shell'],
            File[$db_path[0]],
            File[$db_path[1]],
        ],
    }

    mongodb_database { 'svr_dataset':
        ensure  => present,
        tries   => 10,
        require => [
            Package['mongodb-org-server'],
            Package['mongodb-org-shell'],
            File[$db_path[0]],
            File[$db_path[1]],
        ],
    }

    mongodb_user { $admin_user:
        name          => $admin_user,
        ensure        => present,
        password_hash => mongodb_password($admin_user, $admin_password),
        database      => ['svm_dataset', 'svr_dataset'],
        roles         => ['readWrite', 'dbAdmin'],
        tries         => 10,
        require       => [
            Package['mongodb-org-server'],
            Package['mongodb-org-shell'],
            Mongodb_database['svm_dataset'],
            Mongodb_database['svr_dataset'],
            File[$db_path[0]],
            File[$db_path[1]],
        ],
    }
}
