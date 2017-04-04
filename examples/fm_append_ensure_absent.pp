#@PDQTest
fm_append { "/tmp/fm_append.txt":
  ensure => absent,
  data   => "First line\nSecond line",
}
