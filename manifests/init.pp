###
### Configures mongodb cluster
###
class mongodb_cluster (
    $root_dir            = $::mongodb_cluster::root_dir,
    $dbPath              = $::mongodb_cluster::dbPath,
    $journal             = $::mongodb_cluster::journal,
    $verbosity           = $::mongodb_cluster::verbosity,
    $destination         = $::mongodb_cluster::destination,
    $logAppend           = $::mongodb_cluster::logAppend,
    $systemLogPath       = $::mongodb_cluster::systemLogPath,
    $port                = $::mongodb_cluster::port,
    $bindIp              = $::mongodb_cluster::bindIp,
    $pidfilepath         = $::mongodb_cluster::pidfilepath,
    $keyserver           = $::mongodb_cluster::keyserver,
    $mongodb_key         = $::mongodb_cluster::mongodb_key,
    $mongodb_source_list = $::mongodb_cluster::source_list,
    $authorization       = $::mongodb_cluster::authorization,
    $hostname            = $::mongodb_cluster::hostname,
    $username            = $::mongodb_cluster::username,
    $password            = $::mongodb_cluster::password,
    $admin_user          = $::mongodb_cluster::admin_run,
    $admin_password      = $::mongodb_cluster::password,
    $mongodb_host        = $::mongodb_cluster::host,
    $mongodb_port        = $::mongodb_cluster::port,
    $mongodb_auth        = $::mongodb_cluster::auth,
    $mongodb_replset     = $::mongodb_cluster::replset,
    $mongodb_smallfiles  = $::mongodb_cluster::smallfiles,
    $mongodb_configsvr   = $::mongodb_cluster::configsvr,
    $mongodb_verbose     = $::mongodb_cluster::verbose,
    $mongodb_keyfile     = $::mongodb_cluster::keyfile,
    $mongodb_key         = $::mongodb_cluster::key,
    $mongodb_10gen       = $::mongodb_cluster::manage_package_repo,
) inherits ::mongodb_cluster::params {
    class { 'mongodb_cluster::install' } ->
    class { 'mongodb_cluster::databases' } ->
    Class['mongodb']
}