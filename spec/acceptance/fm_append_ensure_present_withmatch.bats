@test "Last 3 lines match new data" {
  FOOTER=$(tail -3 /tmp/fm_append.txt)
  # must use literal LF - bash won't match \n
  WANTED='# append this
aaa=bbb
EOF'
  [ "$FOOTER" = "$WANTED" ]
}

@test "stale aaa value gone" {
  ! grep 'aaa=xxx' /tmp/fm_append.txt
}

@test "body start intact" {
  grep 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor' /tmp/fm_append.txt
}

@test "body end intact" {
  grep 'culpa qui officia deserunt mollit anim id est laborum' /tmp/fm_append.txt
}
