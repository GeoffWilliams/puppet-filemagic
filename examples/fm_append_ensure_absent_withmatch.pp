#@PDQTest
fm_append { "/tmp/fm_append.txt":
  ensure      => absent,
  match_start => '(# append this|aaa=)',
  data        => [
    '# append this',
    'aaa=bbb',
    'EOF',
  ]
}
