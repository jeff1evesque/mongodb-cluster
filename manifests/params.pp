###
### params.pp: default class parameters.
###
### @dbPath, must successively build up to fullpath.
###
class mongodb_cluster::params {
    ## local variables: conditionally load hiera
    ##
    ## Note: yaml keys cannot contain '.', so regsubst() is used. Likewise, the
    ##       corresponding yaml key, implements underscores instead of '.' for
    ##       nodes certificate name.
    ##
    $hiera                   = lookup([
        regsubst($trusted['certname'], '\.', '_', 'G'),
    ], 'default_value' => false)
    $run                     = true
    $security_authorization  = true

    if $hiera {
        $root_dir            = $hiera['root_dir']
        $dbPath              = $hiera['mongodb']['storage']['dbPath']
        $journal             = $hiera['mongodb']['storage']['journal']['enabled']
        $verbosity           = $hiera['mongodb']['systemLog']['verbosity']
        $destination         = $hiera['mongodb']['systemLog']['destination']
        $logAppend           = $hiera['mongodb']['systemLog']['logAppend']
        $systemLogPath       = $hiera['mongodb']['systemLog']['systemLogPath']
        $port                = $hiera['mongodb']['net']['port']
        $bindIp              = $hiera['bindIp']
        $pidfilepath         = $hiera['mongodb']['processManagement']['pidfilepath']
        $keyserver           = $hiera['mongodb']['keyserver']
        $mongodb_key         = $hiera['mongodb']['mongodb_key']
        $mongodb_source_list = $hiera['mongodb']['source_list']
        $authorization       = $hiera['mongodb']['security']['authorization']
        $hostname            = $hiera['mongodb']['hostname']
        $username            = $hiera['mongodb']['username']
        $password            = $hiera['mongodb']['password']
        $admin_user          = $hiera['mongodb']['admin_user']
        $admin_password      = $hiera['mongodb']['admin_password']
        $mongodb_host        = $hiera['mongodb']['host']
        $mongodb_port        = $hiera['mongodb']['port']
        $mongodb_auth        = $hiera['mongodb']['auth']
        $mongodb_replset     = $hiera['replset']
        $mongodb_smallfiles  = $hiera['mongodb']['smallfiles']
        $mongodb_configsvr   = $hiera['configsvr']
        $mongodb_verbose     = $hiera['mongodb']['verbose']
        $mongodb_10gen       = $hiera['mongodb']['manage_package_repo']
    }

    else {
        $root_dir            = '/var/machine-learning'
        $dbPath              = ['/data', '/data/db']
        $journal             = true
        $verbosity           = 1
        $destination         = 'file'
        $logAppend           = true
        $systemLogPath       = '/var/log/mongodb/mongod.log'
        $port                = 27017
        $bindIp              = ['127.0.0.1']
        $pidfilepath         = '/var/run/mongod.pid'
        $keyserver           = 'hkp://keyserver.ubuntu.com:80'
        $mongodb_key         = '9DA31620334BD75D9DCB49F368818C72E52529D4'
        $mongodb_source_list = 'deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse'
        $authorization       = 'enabled'
        $hostname            = 'mongodb'
        $username            = 'authenticated'
        $password            = 'password'
        $admin_user          = 'root'
        $admin_password      = 'password'
        $mongodb_host        = ['test']
        $mongodb_port        = 27017
        $mongodb_auth        = false
        $replset_config      = $hiera['mongodb']['replset']
        $mongodb_smallfiles  = false
        $mongodb_configsvr   = false
        $mongodb_verbose     = false
        $mongodb_10gen       = $hiera['mongodb']['manage_package_repo']
    }
}
