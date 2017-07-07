# manifests/init.pp

class debian_bind (
  Boolean                                   $chroot                 = false,
  Boolean                                   $service_reload         = true,
  String                                    $servicename            = $::bind::params::servicename,
  String                                    $packagenameprefix      = $::bind::params::packagenameprefix,
  String                                    $binduser               = $::bind::params::binduser,
  String                                    $bindgroup              = $::bind::params::bindgroup,
  Hash[String, Array[String]]               $acls                   = {},
  Hash[String, Array[String]]               $masters                = {},
  Integer                                   $listen_on_port         = 53,
  Array[String]                             $listen_on_addr         = [ '127.0.0.1' ],
  Integer                                   $listen_on_v6_port      = 53,
  Array[String]                             $listen_on_v6_addr      = [ '::1' ],
  Array[String]                             $forwarders             = [],
  String                                    $directory              = '/var/cache/bind',
  Array[String]                             $allow_query            = [ 'localhost' ],
  Array[String]                             $allow_query_cache      = [],
  String                                    $recursion              = 'yes',
  Array[String]                             $allow_recursion        = [],
  Array[String]                             $allow_transfer         = [],
  Array[String]                             $check_names            = [],
  Hash[String, String]                      $extra_options          = {},
  String                                    $dnssec_enable          = 'yes',
  String                                    $dnssec_validation      = 'yes',
  String                                    $dnssec_lookaside       = 'auto',
  Hash[String, Array[String]]               $zones                  = {},
  Hash[String, Array[String]]               $keys                   = {},
  Array[String]                             $includes               = [],
  Hash[String, Hash[String, Array[String]]] $views                  = {},
  Optional[String]                          $managed_keys_directory = undef,
  Optional[String]                          $hostname               = undef,
  Optional[String]                          $server_id              = undef,
  Optional[String]                          $version                = undef,
  Optional[String]                          $dump_file              = undef,
  Optional[String]                          $statistics_file        = undef,
  Optional[String]                          $memstatistics_file     = undef,
) inherits ::bind::params {
  if (!$dump_file) {
    $use_dump_file          = "$directory/cache_dump.db"
  }
  if (!$statistics_file) {
    $use_statistics_file    = "$directory/named_stats.txt"
  }
  if (!$memstatistics_file) {
    $use_memstatistics_file = "$directory/named_mem_stats.txt"
  }

  class { '::bind':
    chroot            => $chroot,
    service_reload    => $service_reload,
    servicename       => $servicename,
    packagenameprefix => $packagenameprefix,
    binduser          => $binduser,
    bindgroup         => $bindgroup,
  }

  $packagename      = "$packagenameprefix$::bind::packagenamesuffix"
  $servicename_full = "$servicename$::bind::servicenamesuffix"

  if (!defined(File[$directory])) {
    file { "$directory":
      ensure  => directory,
      owner   => $binduser,
      group   => $bindgroup,
      mode    => '0750',
      require => Package[$packagename],
      notify  => Service[$servicename_full],
    }
  }

  file { "$directory/named.ca":
    ensure  => link,
    target  => '/etc/bind/db.root',
    require => [
      File[$directory],
      Package[$packagename],
    ],
    notify  => Service[$servicename_full],
  }
  file { '/etc/bind/named.conf.rfc1912-zones':
    ensure  => file,
    source  => "puppet:///modules/$module_name/named.conf.rfc1912-zones",
    require => Package[$packagename],
    notify  => Service[$servicename_full],
  }
  file { '/etc/named.rfc1912.zones':
    ensure  => link,
    target  => '/etc/bind/named.conf.rfc1912-zones',
    require => File['/etc/bind/named.conf.rfc1912-zones'],
    notify  => Service[$servicename_full],
  }

  bind::server::conf { '/etc/bind/named.conf':
    acls                    => $acls,
    masters                 => $masters,
    listen_on_port          => "$listen_on_port",
    listen_on_addr          => $listen_on_addr,
    listen_on_v6_port       => "$listen_on_v6_port",
    listen_on_v6_addr       => $listen_on_v6_addr,
    forwarders              => $forwarders,
    directory               => $directory,
    allow_query             => $allow_query,
    allow_query_cache       => $allow_query_cache,
    recursion               => $recursion,
    allow_recursion         => $allow_recursion,
    allow_transfer          => $allow_transfer,
    check_names             => $check_names,
    extra_options           => $extra_options,
    dnssec_enable           => $dnssec_enable,
    dnssec_validation       => $dnssec_validation,
    dnssec_lookaside        => $dnssec_lookaside,
    zones                   => $zones,
    keys                    => $keys,
    includes                => $includes,
    views                   => $views,
    managed_keys_directory  => $managed_keys_directory,
    hostname                => $hostname,
    server_id               => $server_id,
    version                 => $version,
    dump_file               => $use_dump_file,
    statistics_file         => $use_statistics_file,
    memstatistics_file      => $use_memstatistics_file,
    require                 => [
      File[$directory],
      File["$directory/named.ca"],
      File['/etc/named.rfc1912.zones'],
    ],
  }
}

# vim: set ts=2 sw=2 et syn=puppet:
