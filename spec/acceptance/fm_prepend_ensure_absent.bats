@test "First line gone" {
  ! grep 'First line' /tmp/fm_prepend.txt
}

@test "Second line gone" {
  ! grep 'Second line' /tmp/fm_prepend.txt
}
