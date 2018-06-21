#@PDQTest
fm_replace { "/tmp/foo.txt":
  ensure => absent,
  match  => "remove this line"
}

fm_replace { "/tmp/foo.txt:also this line":
  ensure => absent,
  path   => "/tmp/foo.txt",
  match  => "also this line",
}