@test "regex removed" {
    ! grep -i jack /tmp/fm_gsub.txt
}

@test "regex replaced" {
    grep -i geoff /tmp/fm_gsub.txt
}