###
### Install required components for mongodb cluster.
###
class mongodb_cluster::install {
    ## local variables
    $admin_user         = $::mongodb_cluster::run
    $admin_password     = $::mongodb_cluster::password
    $mongodb_host       = $::mongodb_cluster::host
    $mongodb_port       = $::mongodb_cluster::port
    $mongodb_auth       = $::mongodb_cluster::auth
    $mongodb_replset    = $::mongodb_cluster::replset
    $mongodb_smallfiles = $::mongodb_cluster::smallfiles
    $mongodb_configsvr  = $::mongodb_cluster::configsvr
    $mongodb_verbose    = $::mongodb_cluster::verbose
    $mongodb_keyfile    = $::mongodb_cluster::keyfile
    $mongodb_key        = $::mongodb_cluster::key

    ## recommended repository
    class { '::mongodb::globals':
        manage_package_repo => $mongodb_10gen,
    }

    ## mongodb node
    class { '::mongodb::server':
        bind_ip        => $mongodb_ip,
        port           => $mongodb_port,
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
