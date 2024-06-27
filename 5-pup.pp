exec { 'Test2':
    command => '/usr/bin/echo Command exited successfully so file is not created. > /tmp/test2.txt',
    unless  => '/usr/bin/which bash',
}
