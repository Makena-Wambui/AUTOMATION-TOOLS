exec { 'Test2':
    command => '/usr/bin/echo "Testing unless" > /tmp/test2.txt',
    unless  => '/usr/bin/which php',
}
