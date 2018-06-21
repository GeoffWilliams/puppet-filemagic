#@PDQTest
fm_prepend { "/tmp/fm_prepend.txt":
  ensure      => present,
  match_end   => 'end of prepended data',
  data        => "# prepend this\naaa=bbb\nend of prepended data",
}
