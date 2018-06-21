cat > /tmp/fm_prepend.txt <<END
aaa=xxx
end of prepended data
END
cat /testcase/spec/testdata/input.txt >> /tmp/fm_prepend.txt
