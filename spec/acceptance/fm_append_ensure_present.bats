@test "First 2 lines match new data" {
  HEADER=$(tail -2 /tmp/fm_append.txt)
  # must use literal LF - bash won't match \n
  WANTED='First line
Second line'
  [ "$HEADER" = "$WANTED" ]
}

@test "body start intact" {
  grep 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor' /tmp/fm_append.txt
}

@test "body end intact" {
  grep 'culpa qui officia deserunt mollit anim id est laborum' /tmp/fm_append.txt
}
