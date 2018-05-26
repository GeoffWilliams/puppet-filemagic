#@PDQTest
fm_gsub { "/tmp/fm_gsub.txt":
  ensure => absent,
  match  => "jack",
  flags  => "i"
}