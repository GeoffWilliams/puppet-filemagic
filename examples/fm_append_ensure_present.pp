#@PDQTest
fm_append { "/tmp/fm_append.txt":
  ensure => present,
  data   => "First line\nSecond line",
}
