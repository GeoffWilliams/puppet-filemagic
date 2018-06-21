#@PDQTest
fm_prepend { "/tmp/fm_prepend.txt":
  ensure      => absent,
  match_end   => 'end of prepended data',
}
