@test "matched line removed" {
    ! grep "remove this line" /tmp/foo.txt
}

@test "unmatched line left alone" {
    grep "no remove" /tmp/foo.txt
}