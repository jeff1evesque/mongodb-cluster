###
### Run mongod instance.
###
class mongodb_cluster::run {
    ## local variables
    $mongodb_node  = lookup('mongodb_node')
    $storage       = $mongodb_node['storage']
    $systemLog     = $mongodb_node['systemLog']
    $net           = $mongodb_node['net']
    $process       = $mongodb_node['processManagement']
    $replset       = $mongodb_node['replication']
    $shard         = $mongodb_node['sharding']
    $mongodb_type  = $mongodb_node['type']
    $engine        = $storage['engine']
    $dbPath        = $storage['dbPath']
    $journal       = $storage['journal']['enabled']
    $smallFiles    = $storage['mmapv1']['smallFiles']
    $verbosity     = $systemLog['verbosity']
    $destination   = $systemLog['destination']
    $logAppend     = $systemLog['logAppend']
    $systemLogPath = $systemLog['systemLogPath']
    $port          = $net['port']
    $bindIp        = $net['bindIp']
    $fork          = $process['fork']
    $pidfilepath   = $process['pidfilepath']
    $replSetName   = $replset['replSetName']
    $clusterRole   = $shard['clusterRole']
    $configDB      = $shard['configDB']

    ## ensure base path
    file { $dbPath:
        ensure => directory,
        mode   => '0755',
        owner  => mongodb,
        group  => root,
    }

    if ($mongodb_type == 'mongod') {
        ## general mongod configuration
        file { '/etc/mongod.conf':
            ensure  => file,
            content => dos2unix(template('mongodb_cluster/mongod.conf.erb')),
            mode    => '0644',
            owner   => mongodb,
            group   => root,
            notify  => Service['upstart-mongod'],
        }

        ## mongod init script
        file { '/etc/init/upstart-mongod.conf':
            ensure  => file,
            content => dos2unix(template('mongodb_cluster/upstart-mongod.conf.erb')),
            mode    => '0644',
            owner   => mongodb,
            group   => root,
            notify  => Service['upstart-mongod'],
        }

        ## enforce mongod init script
        service { 'upstart-mongod':
            ensure  => running,
            enable  => true,
            require => [
                File['/etc/mongod.conf'],
                File['/etc/init/upstart-mongod.conf'],
            ],
        }
    }

    elsif ($mongodb_type == 'mongos') {
        ## general mongos configuration
        file { '/etc/mongod.conf':
            ensure  => file,
            content => dos2unix(template('mongodb_cluster/mongos.conf.erb')),
            mode    => '0644',
            owner   => mongodb,
            group   => root,
            notify  => Service['upstart-mongos'],
        }

        ## mongos init script
        file { '/etc/init/upstart-mongos.conf':
            ensure  => file,
            content => dos2unix(template('mongodb_cluster/upstart-mongos.conf.erb')),
            mode    => '0644',
            owner   => mongodb,
            group   => root,
            notify  => Service['upstart-mongos'],
        }

        ## enforce mongos init script
        service { 'upstart-mongos':
            ensure  => running,
            enable  => true,
            require => [
                File['/etc/mongos.conf'],
                File['/etc/init/upstart-mongos.conf'],
            ],
        }
    }
}