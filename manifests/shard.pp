###
### Configure sharded replica sets.
###
class mongodb_cluster::shard {
    ## local variables
    $mongodb_node  = lookup('mongodb_node')
    $storage       = $mongodb_node['storage']
    $systemLog     = $mongodb_node['systemLog']
    $net           = $mongodb_node['net']
    $process       = $mongodb_node['processManagement']
    $replset       = $mongodb_node['replication']
    $shard         = $mongodb_node['sharding']
    $engine        = $storage['engine']
    $dbPath        = $storage['dbPath'][1]
    $journal       = $storage['journal']['enabled']
    $smallFiles    = $storage['mmapv1']['smallFiles']
    $verbosity     = $systemLog['verbosity']
    $destination   = $systemLog['destination']
    $logAppend     = $systemLog['logAppend']
    $systemLogPath = $systemLog['systemLogPath']
    $port          = $net['port']
    $bindIp        = $net['bindIp']
    $fork          = $process['fork']
    $pidfilepath   = $process['fork']
    $replSetName   = $replset['replSetName']
    $clusterRole   = $shard['clusterRole']

    file { '/etc/mongod.conf':
        ensure  => file,
        content => dos2unix(template('mongodb_cluster/mongodb.conf.erb')),
    }
}