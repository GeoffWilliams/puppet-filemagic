#@PDQTest
fm_gsub { "/tmp/fm_gsub.txt":
  ensure => present,
  data   => "geoff",
  match  => "jack",
  flags  => "i",
}

# test writing more then one change to a file
fm_gsub { "/tmp/fm_gsub.txt:work":
  ensure => present,
  path   => "/tmp/fm_gsub.txt",
  data   => "sleep",
  match  => "work",
  flags  => "i",
}