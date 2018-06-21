#@PDQTest
fm_append { "/tmp/fm_append.txt":
  ensure      => present,
  match_start => '(# append this|aaa=)',
  data        => "# append this\naaa=bbb\nend of appended data"
}
