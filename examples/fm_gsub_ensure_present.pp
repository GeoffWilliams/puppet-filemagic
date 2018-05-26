#@PDQTest
fm_gsub { "/tmp/fm_gsub.txt":
  ensure => present,
  data   => "geoff",
  match  => "jack",
  flags  => "i",
}