require 'puppetlabs_spec_helper/module_spec_helper'
TESTCASE = {
  :appended  => File.join('spec', 'fixtures', 'testcase', 'appended.txt'),
  :prepended => File.join('spec', 'fixtures', 'testcase', 'prepended.txt'),
  :unmerged  => File.join('spec', 'fixtures', 'testcase', 'unmerged.txt'),
  :data     => "Line 1\nLine 2",
}
