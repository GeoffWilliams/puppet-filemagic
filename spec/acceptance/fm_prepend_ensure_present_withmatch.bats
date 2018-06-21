@test "First 3 lines match new data" {
  HEADER=$(head -3 /tmp/fm_prepend.txt)
  # must use literal LF - bash won't match \n
  WANTED='# prepend this
aaa=bbb
end of prepended data'
  [ "$HEADER" = "$WANTED" ]
}

@test "stale aaa value gone" {
  ! grep 'aaa=xxx' /tmp/fm_prepend.txt
}

@test "body start intact" {
  grep 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor' /tmp/fm_append.txt
}

@test "body end intact" {
  grep 'culpa qui officia deserunt mollit anim id est laborum' /tmp/fm_append.txt
}
