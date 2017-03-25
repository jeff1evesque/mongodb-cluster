###
### Configures mongodb databases.
###

class mongodb_cluster::databases {
    ## local variables
    $hiera_database = lookup('database')
    $hiera_mongodb  = $hiera_database['mongodb_cluster']
    $hiera_user     = $hiera_mongodb['user']
    $admin_user     = $hiera_user['admin']['name']
    $admin_password = $hiera_user['admin']['password']

    file { '/data/db':
        ensure => 'directory',
        owner  => root,
        group  => root,
        mode   => '0600',
    }

    mongodb::db { 'svm_dataset':
        user          => $admin_user,
        password_hash => $admin_password,
        require       => File['/data/db'],
    }

    mongodb::db { 'svr_dataset':
        user          => $admin_user,
        password_hash => $admin_password,
        require       => File['/data/db'],
    }
}
