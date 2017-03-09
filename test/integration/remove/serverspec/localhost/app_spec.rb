# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'reattach-to-user-namespace::default::remove' do
  describe file('/usr/local/bin/reattach-to-user-namespace') do
    it 'does not exist' do
      expect(subject).to_not be_file
    end
  end

  describe command('/usr/local/bin/reattach-to-user-namespace ls') do
    it 'exits unsuccessfully' do
      expect(subject.exit_status).to_not eq(0)
    end
  end

  describe command('/usr/local/bin/brew list reattach-to-user-namespace') do
    it 'exits unsuccessfully' do
      expect(subject.exit_status).to_not eq(0)
    end
  end
end
