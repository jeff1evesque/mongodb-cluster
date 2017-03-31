###
### Configures mongodb cluster
###

class mongodb_cluster {
    $hiera_mongodb = lookup('mongodb_node')
    $config_server = $hiera_mongodb['sharding']['clusterRole']

    contain mongodb_cluster::install
    if ($config_server != 'configsvr') {
        contain mongodb_cluster::databases
    }
    contain mongodb_cluster::shard
}