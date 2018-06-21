@test "one matched line replaced" {
    grep "replaced" /tmp/foo.txt
}


@test "matched lines removed" {
    ! grep "remove this line" /tmp/foo.txt
}

@test "unmatched line left alone" {
    grep "no remove" /tmp/foo.txt
}

@test "line inserted" {
    grep "line inserted" /tmp/foo.txt
}