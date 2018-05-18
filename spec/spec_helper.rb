require 'puppetlabs_spec_helper/module_spec_helper'
TESTCASE = {
  :appended         => File.join('spec', 'fixtures', 'testcase', 'appended.txt'),
  :prepended        => File.join('spec', 'fixtures', 'testcase', 'prepended.txt'),
  :unmerged         => File.join('spec', 'fixtures', 'testcase', 'unmerged.txt'),
  :partial_append   => File.join('spec', 'fixtures', 'testcase', 'partial_append.txt'),
  :partial_prepend  => File.join('spec', 'fixtures', 'testcase', 'partial_prepend.txt'),
  :replaced         => File.join('spec', 'fixtures', 'testcase', 'replaced.txt'),
  :needs_replace    => File.join('spec', 'fixtures', 'testcase', 'needs_replace.txt'),
  :data             => "Line 1\nLine 2",
}
