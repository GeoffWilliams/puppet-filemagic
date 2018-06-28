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

fm_replace { "/tmp/foo.txt:insert_top":
  ensure            => present,
  path              => "/tmp/foo.txt",
  data              => "line inserted at top",
  match             => "will never match",
  insert_if_missing => true,
  insert_at         => "top"
}

fm_replace { "/tmp/foo.txt:insert_bottom":
  ensure            => present,
  path              => "/tmp/foo.txt",
  data              => "line inserted at bottom",
  match             => "will never match",
  insert_if_missing => true,
  insert_at         => "bottom"
}

fm_replace { "/tmp/foo.txt:insert_3":
  ensure            => present,
  path              => "/tmp/foo.txt",
  data              => "line inserted at 3",
  match             => "will never match",
  insert_if_missing => true,
  insert_at         => 3,
}