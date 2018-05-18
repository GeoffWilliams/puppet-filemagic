require 'spec_helper'
require 'puppet_x/filemagic'

describe PuppetX::FileMagic do
  it 'exists? prepend :present detects need to append to unmerged file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:unmerged], TESTCASE[:data], false, -1, :present)).to be false
  end

  it 'exists? prepend :absent detects need to not append to already un-appended file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:unmerged], TESTCASE[:data], false, -1, :absent)).to be false
  end

  it 'exists? prepend :present detects need to not append to already fixed file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:prepended], TESTCASE[:data], false, -1, :present)).to be true
  end

  it 'exists? prepend :absent detects need to un-append to already fixed file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:prepended], TESTCASE[:data], false, -1, :absent)).to be true
  end

  it 'exists? prepend :present detects need to fixup partial file (matches old data)' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:partial_prepend], TESTCASE[:data], 'gonesky', -1, :present)).to be false
  end

  it 'exists? prepend :absent detects need to fixup partial file (matches old data)' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:partial_prepend], TESTCASE[:data], 'gonesky', -1, :absent)).to be true
  end

  it 'exists? append :present detects need to append to unmerged file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:unmerged], TESTCASE[:data], false, +1, :present)).to be false
  end

  it 'exists? append :absent  detects need to append to unmerged file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:unmerged], TESTCASE[:data], false, +1, :absent)).to be false
  end

  it 'exists? append :present detects need to not append to already fixed file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:appended], TESTCASE[:data], false, +1, :present)).to be true
  end

  it 'exists? append :absent detects need to not append to already fixed file' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:appended], TESTCASE[:data], false, +1, :absent)).to be true
  end

  it 'exists? append :present detects need to fixup partial file (matches old data)' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:partial_append], TESTCASE[:data], 'gonesky', +1, :present)).to be false
  end

  it 'exists? append :absent detects need to fixup partial file (matches old data)' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:partial_append], TESTCASE[:data], 'gonesky', +1, :absent)).to be true
  end


  it 'finds the index of the first match' do
    expect(PuppetX::FileMagic::get_match(['a','b','c','b','a'], /b/, true)).to be 1
  end

  it 'finds the index of the last match' do
    expect(PuppetX::FileMagic::get_match(['a','b','c','b','a'], /b/, false)).to be 3
  end

  it 'returns -1 if no match' do
    expect(PuppetX::FileMagic::get_match(['a','b'], /c/, false)).to be -1
  end

  it 'returns -1 if no regex' do
    expect(PuppetX::FileMagic::get_match([], false, false)).to be -1
  end

  it 'exists? returns false when replacements already applied' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:replaced], TESTCASE[:data], 'gonsky', +1, :present)).to be false
  end

  it 'exists? returns true when replacements are needed' do
    expect(PuppetX::FileMagic::exists?(TESTCASE[:needs_replace], TESTCASE[:data], 'needs replace', +1, :replace)).to be true
  end
end
