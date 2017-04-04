require 'spec_helper'
require 'puppet_x/filemagic'

describe PuppetX::FileMagic do
  it 'prepend detects need to append to unmerged file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:unmerged], TESTCASE[:data], -1)).to be false
  end

  it 'prepend detects need to not append to already fixed file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:prepended], TESTCASE[:data], -1)).to be true
  end

  it 'append detects need to append to unmerged file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:unmerged], TESTCASE[:data], +1)).to be false
  end

  it 'append detects need to not append to already fixed file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:appended], TESTCASE[:data], +1)).to be true
  end

end
