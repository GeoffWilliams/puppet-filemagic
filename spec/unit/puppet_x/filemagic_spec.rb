require 'spec_helper'
require 'puppet_x/filemagic'

describe PuppetX::FileMagic do
  #
  # prepend
  #
  context "prepend" do
    it 'exists? (ensure=>present) detects need to append to input file' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:input], TESTCASE[:data], false, nil, :prepend, false)
      ).to be false
    end

    it 'exists? (ensure=>absent) detects need to not append to already un-appended file' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:input], TESTCASE[:data], false, nil, :prepend, true)
      ).to be false
    end

    it 'exists? (ensure=>present) detects need to not append to already fixed file' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:prepended], TESTCASE[:data], false, nil,:prepend, false)
      ).to be true
    end

    it 'exists? (ensure=>absent) detects need to un-append to already fixed file' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:prepended], TESTCASE[:data], false, nil, :prepend, true)
      ).to be true
    end

    it 'exists? (ensure=>present) detects need to fixup partial file (by regex)' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:partial_prepend], TESTCASE[:data], 'gonesky', nil, :prepend, false)
      ).to be false
    end

    it 'exists? (ensure=>present) detects need to fixup partial file (by data)' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:partial_prepend], "no match\ngonesky", nil, nil, :prepend, false)
      ).to be false
    end

    it 'exists? (ensure=>absent) detects need to fixup partial file (by regex)' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:partial_prepend], TESTCASE[:data], 'gonesky', nil,:prepend, true)
      ).to be true
    end

    it 'exists? (ensure=>absent) detects need to fixup partial file (by data)' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:partial_prepend], "no match\ngonesky", nil, nil, :append, true)
      ).to be true
    end
  end

  #
  # append
  #
  context "append" do
    it 'exists? (ensure=>present) detects need to append to unappended file' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:input], TESTCASE[:data], false, nil, :append, false)
      ).to be false
    end

    it 'exists? (ensure=>absent) detects need to append to unappended file' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:input], TESTCASE[:data], false, nil, :append, true)
      ).to be false
    end

    it 'exists? (ensure=>present) detects need to not append to already fixed file' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:appended], TESTCASE[:data], false, nil,:append, false)
      ).to be true
    end

    it 'exists? (ensure=>present)  detects need to not append to already fixed file' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:appended], TESTCASE[:data], false, nil,:append, true)
      ).to be true
    end

    it 'exists? (ensure=>present) detects need to fixup partial file (by regex)' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:partial_append], TESTCASE[:data], 'gonesky', nil, :append, false)
      ).to be false
    end

    it 'exists? (ensure=>present) detects need to fixup partial file (by data)' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:partial_append], "gonesky\nno match", nil, nil, :append, false)
      ).to be false
    end


    it 'exists? (ensure=>absent) detects need to fixup partial file (by regex)' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:partial_append], TESTCASE[:data], 'gonesky', nil, :append, true)
      ).to be true
    end

    it 'exists? (ensure=>absent) detects need to fixup partial file (by data)' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:partial_append], "gonesky\nno match" , nil, nil, :append, true)
      ).to be true
    end

  end

  #
  # replace
  #
  context "replace" do
    it 'exists? (ensure=>present) detects no need to fire when replacements already applied' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:replaced], TESTCASE[:data], 'gonsky', nil, :replace, false)
      ).to be true
    end

    it 'exists? (ensure=>present) detects need to fire when replacements are needed' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:needs_replace], TESTCASE[:data], 'needs replace', nil, :replace, false)
      ).to be false
    end

    it 'exists? (ensure=>absent) detects need to fire when replacements are needed (regexp match)' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:needs_replace], TESTCASE[:data], 'needs replace', nil, :replace, true)
      ).to be true
    end


    it 'exists? (ensure=>absent) detects need to fire when replacements are needed (data match)' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:needs_replace], TESTCASE[:data], 'will never match', nil, :replace, true)
      ).to be true
    end

    it 'exists? (ensure=>absent) detects need not to fire when no data match and no regexp match' do
      expect(
          PuppetX::FileMagic::exists?(TESTCASE[:needs_replace], "not here", 'will never match', nil, :replace, true)
      ).to be false
    end

    #
    # replace_insert
    #
    context "replace_insert" do
      it 'exists? (ensure=>present) detects need to fire (insert)' do
        expect(
            PuppetX::FileMagic::exists?(TESTCASE[:needs_replace_insert], TESTCASE[:data], 'gonsky', nil, :replace_insert, false)
        ).to be false
      end

      it 'exists? (ensure=>present) detects need to fire (regexp match)' do
        expect(
            PuppetX::FileMagic::exists?(TESTCASE[:needs_replace], TESTCASE[:data], 'needs replace', nil, :replace_insert, false)
        ).to be false
      end


      it 'exists? (ensure=>present) detects no need to fire when replacements already applied' do
        expect(
            PuppetX::FileMagic::exists?(TESTCASE[:replaced_insert], TESTCASE[:data], 'gonsky', nil, :replace_insert, false)
        ).to be true
      end


      it 'exists? (ensure=>absent) detects need to fire when replacements are needed (regexp match)' do
        expect(
            PuppetX::FileMagic::exists?(TESTCASE[:needs_replace], TESTCASE[:data], 'needs replace', nil, :replace_insert, true)
        ).to be true
      end


      it 'exists? (ensure=>absent) detects need to fire when replacements are needed (data match)' do
        expect(
            PuppetX::FileMagic::exists?(TESTCASE[:needs_replace], TESTCASE[:data], 'will never match', nil, :replace_insert, true)
        ).to be true
      end

      it 'exists? (ensure=>absent) detects need not to fire when no data match and no regexp match' do
        expect(
            PuppetX::FileMagic::exists?(TESTCASE[:needs_replace], "not here", 'will never match', nil, :replace_insert, true)
        ).to be false
      end

    end

    #
    # gsub
    #
    context "gsub" do
      it 'exists? (ensure=>present) detects need to fire when regexp match' do
        expect(
            PuppetX::FileMagic::exists?(TESTCASE[:gsub], TESTCASE[:data], 'jack', nil, :gsub, false)
        ).to be false
      end

      it 'exists? (ensure=>absent) detects need fire when regexp match' do
        expect(
            PuppetX::FileMagic::exists?(TESTCASE[:gsub], TESTCASE[:data], 'jack', nil, :gsub, true)
        ).to be true
      end

      it 'exists? (ensure=>present) detects need not to fire when regexp not matched' do
        expect(
            PuppetX::FileMagic::exists?(TESTCASE[:gsub], TESTCASE[:data], 'nothere', nil, :gsub, false)
        ).to be true
      end


      it 'exists? (ensure=>absent) detects need not to fire when regexp not matched' do
        expect(
            PuppetX::FileMagic::exists?(TESTCASE[:gsub], TESTCASE[:data], 'nothere', nil, :gsub, true)
        ).to be false
      end


    end
  end

  #
  # get_match_regex
  #
  context "get_match_regex function" do
    it 'finds the index of the first match' do
      expect(PuppetX::FileMagic::get_match_regex(['a','b','c','b','a'], 'b', nil, true)).to be 1
    end

    it 'finds the index of the last match' do
      expect(PuppetX::FileMagic::get_match_regex(['a','b','c','b','a'], 'b', nil, false)).to be 3
    end

    it 'returns -1 if no match' do
      expect(PuppetX::FileMagic::get_match_regex(['a','b'], 'c', nil, false)).to be -1
    end

    it 'returns -1 if no regex' do
     expect(PuppetX::FileMagic::get_match_regex([], false, nil, false)).to be -1
    end
  end

  #
  # get_match_lines
  #
  context "get_match_lines function" do
    it 'does not error on empty input file or lines' do
      expect(PuppetX::FileMagic::get_match_lines([], "", 0)).to be 0
    end


    it 'counts matches at BOF' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['a', 'b'], -1)).to be -1
    end

    it 'counts matches in MOF' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['b', 'c'], 0)).to be -1
    end

    it 'counts matches at EOF' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['c', 'd'], 1)).to be -1
    end

    it 'counts partial matches at BOF p1' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['z', 'b'], -1)).to be 1
    end

    it 'counts partial matches at BOF p2' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['a', 'z'], -1)).to be 1
    end

    it 'counts partial matches at BOF p3' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['b', 'z'], -1)).to be 1
    end

    it 'counts partial matches in MOF p1' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['c', 'z'], 0)).to be 1
    end

    it 'counts partial matches in MOF p2' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['z', 'c'], 0)).to be 1
    end


    it 'counts partial matches at EOF p1 ' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['c', 'z'], 1)).to be 1
    end

    it 'counts partial matches at EOF p2 ' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['z', 'd'], 1)).to be 1
    end

    it 'counts partial matches at EOF p3 ' do
      expect(PuppetX::FileMagic::get_match_lines(['a','b','c','d'], ['z', 'c'], 1)).to be 1
    end

  end


end
