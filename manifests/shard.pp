###
### Configure sharded replica sets.
###
class mongodb_cluster::shard {
    file { '/etc/mongod.conf':
        ensure  => file,
        content => dos2unix(template('mongodb_cluster/mongodb.conf.erb')),
    }
}