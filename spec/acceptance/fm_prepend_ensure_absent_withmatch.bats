# BATS test file to run after executing 'examples/init.pp' with puppet.
#
# For more info on BATS see https://github.com/sstephenson/bats

# Tests are really easy! just the exit status of running a command...
@test "line 2 gone" {
  grep -v 'aaa=bbb' /tmp/fm_prepend.txt
}

@test "line 3 gone" {
  grep -v 'end of prepended data' /tmp/fm_prepend.txt
}

@test "body start intact" {
  grep 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor' /tmp/fm_append.txt
}

@test "body end intact" {
  grep 'culpa qui officia deserunt mollit anim id est laborum' /tmp/fm_append.txt
}

@test "stale aaa value gone" {
  ! grep 'aaa=xxx' /tmp/fm_prepend.txt
}
