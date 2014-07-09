
class bind(
  # Params which change often

  # Params which change seldom

) inherits bind::params {
  include boxen::config

  homebrew::formula { 'bind': }

  package { 'boxen/brews/bind':
    ensure    => $version,
    # notify    => Service['riemann'],
    require   => Homebrew::Formula['bind'],
    alias     => 'bind',
  }

  file {
    [$confdir,$logdir]: 
      ensure => directory;

    
    "${confdir}/localhost.zone":
      ensure    => present,
      content   => template('bind/localhost.zone.erb'),
      notify    => Service['bind'];

    "${confdir}/named.local":
      ensure    => present,
      content   => template('bind/named.local.erb'),
      notify    => Service['bind'];
  }

  exec { 'bind.rndc-generate':
    command => "${boxen::config::homebrewdir}/sbin/rndc-confgen -a -c ${rndc_key_file}",
    creates => $rndc_key_file,
    require => Package['bind'],
  }

  concat { $configfile:
    ensure    => present,
    notify    => Service['bind'];
  }
  
  concat::fragment { 'bind.config':
    target  => $configfile,
    content => template('bind/named.conf.erb'),
    order   => '01'
  }

  service { 'dev.named':
    ensure => running,
    enable => true,
    alias  => 'bind',
    require => [
      Package['bind'],
      File['plist.bind'],
      Exec['bind.rndc-generate']
    ],
  }

  file { "/Library/LaunchDaemons/dev.named.plist":
    alias   => 'plist.bind',
    content => template('bind/named.plist.erb'),
    group   => wheel,
    owner   => root;
  }

  # boxen::env_script { 'bind':
  #   ensure   => present,
  #   content  => template('bind/env.sh.erb'),
  #   priority => 'lower',
  # }
}

