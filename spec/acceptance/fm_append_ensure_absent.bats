@test "First line gone" {
  ! grep 'First line' /tmp/fm_append.txt
}

@test "Second line gone" {
  ! grep 'Second line' /tmp/fm_append.txt
}
