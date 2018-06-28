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

@test "line inserted at line 1" {
    awk 'NR==1{print;exit}' /tmp/foo.txt | grep "line inserted at top"
}

@test "line inserted at position 3 (line 4)" {
    awk 'NR==4{print;exit}' /tmp/foo.txt | grep "line inserted at 3"
}

@test "line inserted at bottom {
    awk 'END{print}' /tmp/foo.txt | grep "line inserted at bottom"
}