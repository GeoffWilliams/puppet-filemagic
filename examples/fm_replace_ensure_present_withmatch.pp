#@PDQTest
fm_replace { "/tmp/foo.txt":
  ensure => present,
  data   => "replaced",
  match  => "remove this line",
}