@test "First line gone" {
  ! grep 'First line' /tmp/fm_prepend.txt
}

@test "Second line gone" {
  ! grep 'Second line' /tmp/fm_prepend.txt
}

@test "body start intact" {
  grep 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor' /tmp/fm_append.txt
}

@test "body end intact" {
  grep 'culpa qui officia deserunt mollit anim id est laborum' /tmp/fm_append.txt
}
