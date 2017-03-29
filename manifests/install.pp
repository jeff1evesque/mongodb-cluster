###
### Install required components for mongodb cluster.
###
class mongodb_cluster::install {
#    include mongodb::server::config

    ## local variables
    $hiera_database     = lookup('database')
    $hiera_mongodb      = lookup('mongodb_node')
    $user               = $hiera_database['mongodb_cluster']['user']
    $db_path            = $hiera_database['mongodb_cluster']['db_path']
    $admin_user         = $user['admin']['name']
    $admin_password     = $user['admin']['password']
    $mongodb_ip         = $hiera_mongodb['ip']
    $mongodb_host       = $hiera_mongodb['host']
    $mongodb_port       = $hiera_mongodb['port']
    $mongodb_auth       = $hiera_mongodb['auth']
    $mongodb_replset    = $hiera_mongodb['replset']
    $mongodb_smallfiles = $hiera_mongodb['smallfiles']
    $mongodb_configsvr  = $hiera_mongodb['configsvr']
    $mongodb_fork       = $hiera_mongodb['fork']
    $mongodb_verbose    = $hiera_mongodb['verbose']
    $mongodb_keyfile    = $hiera_mongodb['keyfile']
    $mongodb_key        = $hiera_mongodb['key']
    $mongodb_10gen      = $hiera_mongodb['manage_package_repo']

    ## ensure base path
    file { $db_path[0]:
        ensure => directory,
        mode   => '0755',
        owner  => root,
        group  => root,
    }

    ## recommended repository
    class { '::mongodb::globals':
        manage_package_repo => $mongodb_10gen,
    }

    ## mongodb node
    class { '::mongodb::server':
#        bind_ip        => $mongodb_ip,
        bind_ip        => '0.0.0.0',
        port           => $mongodb_port,
        dbpath         => $db_path[1],
        fork           => $mongodb_fork,
        verbose        => $mongodb_verbose,
        auth           => $mongodb_auth,
        smallfiles     => $mongodb_smallfiles,
        configsvr      => $mongodb_configsvr,
        admin_username => $admin_user,
        admin_password => $admin_password,
        replset        => $mongodb_replset,
    }
    class { '::mongodb::client': }
}
