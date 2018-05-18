#@PDQTest
fm_replace { "/tmp/foo.txt":
  ensure => absent,
  match  => "remove this line"
}