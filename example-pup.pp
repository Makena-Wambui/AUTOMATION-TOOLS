# Example Manifest to automate the installation of an Apache web server within Ubuntu 14.04 system.
# start with a variable definition $doc_root
# This variable will later be used in a resource declaration.

$doc_root = '/var/www/example'

# update the apt cache
# exec resource executes an apt-get update command
exec { 'update-apt':
    command => '/usr/bin/apt-get update'
}

# install apache2
# this package resource installs apache2 package.
# defines that the update-apt resource is a requirement.
# This means this resource will be executed after the update-apt resource is evaluated
package { 'apache2':
    ensure  => 'installed',
    require => Exec['update-apt'],
}

# we use a file resource to create new document root directory.
# file resource can be used to create both directories and files
# Also used for applying templates and copying local files to the remote server.
# This file resource can be executed at any point of the provisioning so we did not need to set require

file { $doc_root:
  ensure => 'directory',
  owner  => 'www-data',
  group  => 'www-data',
  mode   => '0644',
}

# we use another file resource to copy our local index.html file to the document root inside our server.
# source parameter to let Puppet know where to find the original file.
# require option because we need the document root directory to be created first before the execution of this resource.
file { "${doc_root}/index.html":
  ensure  => 'present',
  source  => '/etc/puppetlabs/code/environments/production/modules/main/files/index.html',
  require => File[$doc_root]

}

# we use another file resource to apply the template and notify the service for restart.
# our provisioning is organized in a module called main.
# That is why the template source is main/vhost.erb
# we use require statement to state that the resource is only executed after the package apache2 is installed.
file { '/etc/apache2/sites-available/000-default.conf':
    ensure  => 'present',
    content => template('/etc/puppetlabs/code/environments/production/modules/main/templates/vhost.erb'),
    require => Package['apache2'],
    notify  => Service['apache2'],
}

service { 'apache2':
    ensure => 'stopped',
    enable => false,
}

