@test "line 2 gone" {
  grep -v 'aaa=bbb' /tmp/fm_append.txt
}

@test "line 3 gone" {
  grep -v 'EOF' /tmp/fm_append.txt
}

@test "body start intact" {
  grep 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor' /tmp/fm_append.txt
}

@test "body end intact" {
  grep 'culpa qui officia deserunt mollit anim id est laborum' /tmp/fm_append.txt
}

@test "stale aaa value gone" {
  ! grep 'aaa=xxx' /tmp/fm_append.txt
}
