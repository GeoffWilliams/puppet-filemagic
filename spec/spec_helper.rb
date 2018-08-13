require 'puppetlabs_spec_helper/module_spec_helper'
TESTCASE = {
    :input                => File.join('spec', 'testdata', 'input.txt'),
    :appended             => File.join('spec', 'testdata', 'appended.txt'),
    :prepended            => File.join('spec', 'testdata', 'prepended.txt'),
    :partial_append       => File.join('spec', 'testdata', 'partial_append.txt'),
    :partial_prepend      => File.join('spec', 'testdata', 'partial_prepend.txt'),
    :replaced             => File.join('spec', 'testdata', 'replaced.txt'),
    :needs_replace        => File.join('spec', 'testdata', 'needs_replace.txt'),
    :needs_replace_insert => File.join('spec', 'testdata', 'needs_replace_insert.txt'),
    :replaced_insert      => File.join('spec', 'testdata', 'replaced_insert.txt'),
    :replaced_multiline   => File.join('spec', 'testdata', 'replaced_multiline.txt'),
    :gsub                 => File.join('spec', 'testdata', 'gsub.txt'),
    :data                 => "Line 1\nLine 2",
    :multiline_data       => "option foo\noption bar",
}
