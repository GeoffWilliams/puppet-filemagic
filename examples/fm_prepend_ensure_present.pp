#@PDQTest
fm_prepend { "/tmp/fm_prepend.txt":
  ensure => present,
  data   => "First line\nSecond line",
}
