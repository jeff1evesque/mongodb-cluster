###
### Install required components for mongodb cluster.
###
class mongodb_cluster::install {
    ## local variables
    $mongodb             = lookup('database')
    $packages            = lookup('development')
    $db_path             = $mongodb['mongodb_cluster']['db_path']
    $keyserver           = $packages['keyserver']['apt']
    $mongodb_key         = $packages['keyserver']['mongodb_key']
    $mongodb_source_list = $packages['keyserver']['mongodb_source_list']

    ## https://docs.mongodb.com/v3.4/tutorial/install-mongodb-on-ubuntu/
    exec { 'apt-key-puppetlabs':
        command => "apt-key adv --keyserver ${keyserver} --recv ${mongodb_key}",
        unless  => "apt-key list | grep ${mongodb_key}",
        before  => File['mongodb-list-file'],
        path    => ['/usr/bin', '/bin'],
    }

    file { 'mongodb-list-file':
        path    => '/etc/apt/sources.list.d/mongodb-org-3.4.list',
        content => $mongodb_source_list,
        require => Exec['apt-key-puppetlabs'],
        notify  => Exec['apt_update'],
    }

    exec { 'apt_update':
        command     => 'apt-get update',
        path        => '/usr/bin',
        before      => Package['mongodb-org-server'],
        refreshonly => true,
    }

    package { 'mongodb-org-server':
        ensure  => installed,
    }

    package { 'mongodb-org-shell':
        ensure => installed,
    }

    ## ensure base path
    file { $db_path:
        ensure => directory,
        mode   => '0755',
        owner  => mongodb,
        group  => root,
        require => [
            Package['mongodb-org-server']
        ]
    }
}
