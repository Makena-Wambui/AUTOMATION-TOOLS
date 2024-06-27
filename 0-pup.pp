exec { 'create-tmp-school':
    command => 'usr/bin/echo "I love Puppet" > tmp/school',
    user    => 'www-data',
    group   => 'www-data',
    mode    => '0744',
}
