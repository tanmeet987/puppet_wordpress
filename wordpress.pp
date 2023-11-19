include apt

$packages = ['apache2', 'mysql-server', 'mysql-client', 'php' , 'libapache2-mod-php', 'php-mysql', 'unzip']
$packages.each |String $pkg| {
package{ $pkg:
ensure => installed,

}
service { 'apache2':
  ensure => running,
}
class { 'mysql::server':
  root_password           => 'rootpassword',
}
mysql::db { 'wordpress':
  user     => 'wordpressuser',
  password => 'password',
  host     => 'localhost',
  grant    => ['ALL'],
}
archive { wordpress:
  path          => "/tmp/latest.zip",
  source        => "https://wordpress.org/latest.zip",
  extract       => true,
  extract_path  => '/var/www/html/',

}
    wget::retrieve { 'https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php':
    destination => '/var/www/html/wordpress',
  }
file {"/var/www/html/wordpress/wp-config.php":
ensure => present,
source => "/var/www/html/wordpress/wp-config-sample.php",
}
file {"/var/www/html/wordpress":
ensure => directory,
mode => "775",
owner => "www-data",
group => "www-data",
}
exec { 'apache2_restart':
  command => 'service apache2 restart',
  path => '/usr/sbin',
}

