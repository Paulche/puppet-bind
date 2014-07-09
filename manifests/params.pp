
class bind::params {
  include boxen::config
  
  $version = '9.10.0-P2-boxen1'

  $confdir        = "${boxen::config::configdir}/named"
  $logdir         = "${boxen::config::logdir}/named"

  $rndc_key_file  = "${confdir}/rndc.key"

  $executable     = "${boxen::config::homebrewdir}/sbin/named"
  $configfile     = "${confdir}/named.conf"
}
