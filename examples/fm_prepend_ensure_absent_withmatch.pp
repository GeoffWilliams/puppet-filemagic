#@PDQTest
fm_prepend { "/tmp/fm_prepend.txt":
  ensure      => absent,
  match_end   => 'EOF',
  data        => [
    '# prepend this',
    'aaa=bbb',
    'EOF',
  ]
}
