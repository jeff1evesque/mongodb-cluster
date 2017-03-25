###
### Configures mongodb databases.
###

class mongodb_cluster::databases {
    include mongodb_cluster::install

    ## local variables
    $hiera_database = lookup('database')
    $hiera_mongodb  = $hiera_database['mongodb_cluster']
    $hiera_user     = $hiera_mongodb['user']
    $admin_user     = $hiera_user['admin']['name']
    $admin_password = $hiera_user['admin']['password']
    $db_dir         = ['/data', '/data/db']

    file { $db_dir:
        ensure => 'directory',
        owner  => root,
        group  => root,
        mode   => '0640',
    }

    mongodb_database { 'svm_dataset':
        ensure  => present,
        tries   => 10,
        require => [
            Class['::mongodb::server'],
            Class['::mongodb::client'],
            File[$db_dir],
        ],
    }

    mongodb_database { 'svr_dataset':
        ensure  => present,
        tries   => 10,
        require => [
            Class['::mongodb::server'],
            Class['::mongodb::client'],
            File[$db_dir],
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
            Class['::mongodb::server'],
            Mongodb_database['svm_dataset'],
            Mongodb_database['svr_dataset'],
        ],
    }
}
