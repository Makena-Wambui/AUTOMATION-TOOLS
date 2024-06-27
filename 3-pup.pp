exec { 'Test':
    command => '/usr/bin/echo All possible locations of Python > /tmp/test.txt',
    onlyif  => '/usr/bin/which python',
}
