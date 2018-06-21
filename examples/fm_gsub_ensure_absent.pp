#@PDQTest
fm_gsub { "/tmp/fm_gsub.txt":
  ensure => absent,
  match  => "jack",
  flags  => "i"
}

# test more then one edit in same file
fm_gsub { "/tmp/fm_gsub.txt:bob":
  ensure => absent,
  path   => "/tmp/fm_gsub.txt",
  match  => "bob",
  flags  => "i"
}