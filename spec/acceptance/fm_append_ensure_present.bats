@test "First 2 lines match new data" {
  HEADER=$(head -2 /tmp/fm_append.txt)
  # must use literal LF - bash won't match \n
  WANTED='First line
Second line'
  [ "$HEADER" = "$WANTED" ]
}
