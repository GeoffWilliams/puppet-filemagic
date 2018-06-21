#@PDQTest
fm_replace { "/tmp/foo.txt":
  ensure => present,
  data   => "replaced",
  match  => "remove this line",
}

# check handles multiple edits
fm_replace { "/tmp/foo.txt:also":
  ensure => present,
  path   => "/tmp/foo.txt",
  data   => "also this line",
  match  => "remove also line",
}

fm_replace { "/tmp/foo.txt:insert":
  ensure            => present,
  path              => "/tmp/foo.txt",
  data              => "line inserted",
  match             => "will never match",
  insert_if_missing => true,
}