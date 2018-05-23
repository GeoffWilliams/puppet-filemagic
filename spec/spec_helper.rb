require 'puppetlabs_spec_helper/module_spec_helper'
TESTCASE = {
  :appended         => File.join('spec', 'testdata', 'appended.txt'),
  :prepended        => File.join('spec', 'testdata', 'prepended.txt'),
  :unmerged         => File.join('spec', 'testdata', 'unmerged.txt'),
  :partial_append   => File.join('spec', 'testdata', 'partial_append.txt'),
  :partial_prepend  => File.join('spec', 'testdata', 'partial_prepend.txt'),
  :replaced         => File.join('spec', 'testdata', 'replaced.txt'),
  :needs_replace    => File.join('spec', 'testdata', 'needs_replace.txt'),
  :data             => "Line 1\nLine 2",
}
