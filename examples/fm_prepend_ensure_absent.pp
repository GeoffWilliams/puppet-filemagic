#@PDQTest
fm_prepend { "/tmp/fm_prepend.txt":
  ensure => absent,
  data   => "First line\nSecond line",
}
