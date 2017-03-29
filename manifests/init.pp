###
### Configures mongodb cluster
###

class mongodb_cluster {
    $hiera_mongodb = lookup('mongodb_node')
    $config_server = $hiera_mongodb['configsvr']

    contain mongodb_cluster::install
    if (!$config_server) {
        contain mongodb_cluster::databases
    }
}