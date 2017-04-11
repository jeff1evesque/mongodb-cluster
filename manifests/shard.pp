###
### Run mongod instance.
###
class mongodb_cluster::shard {
    ## local variables
    ##
    ## @replset, yaml hash converted to a json string.
    ##
    $database      = lookup('database')
    $mongodb_node  = lookup('mongodb_node')
    $replset       = $database['mongodb_cluster']['replset']
    $replication   = $mongodb_node['replication']
    $sharding      = $mongodb_node['sharding']
    $initiate_ip   = $sharding['initiate']['ip']
    $initiate_port = $sharding['initiate']['port']
    $replset       = inline_template("<%= require 'json'; @replication['replset'].to_json %>")

    ## initiate replica sets
    exec { 'initiate-replset':
        command  => "mongo --host ${initiate_ip} --port ${initiate_port} --eval 'rs.initiate(${replset});'",
        onlyif   => [
            "mongo --host ${initiate_ip} --port ${initiate_port} --quiet --eval 'quit();'",
            "mongo --host ${initiate_ip} --port ${initiate_port} --quiet --eval 'rs.status()[\"ok\"]');",
        ],
        path     => '/usr/bin',
    }

    ## add shards to the cluster
    ##
    ## Note: need 'shell' provider for subshell implementation.
    ##
    $replset.each |String $type, $set| {
        if ($replset != 'csrs') {
            $set.each|String $host|
                exec { "add-${replset}-${host}":
                    command  => "mongo --host ${initiate_ip} --port ${initiate_port} --eval 'sh.addShard(\"${replset}/${host}.mongodb.com:27018\");'",
                    onlyif   => [
                        "mongo --host ${initiate_ip} --port ${initiate_port} --quiet --eval 'quit();'",
                        "mongo --host ${initiate_ip} --port ${initiate_port} --quiet --eval 'sh.status()';",
                        dos2unix(template('mongodb_cluster/shard-status.erb')),
                    ],
                    path     => [
                        '/bin',
                        '/usr',
                        '/usr/bin',
                    ],
                    provider => shell,
                }
            }
        }
    }

    ## enable sharding for database(s)

    ## shard a collection
}