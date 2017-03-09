# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'reattach-to-user-namespace::default::direct' do
  describe file('/usr/local/bin/reattach-to-user-namespace') do
    it 'exists' do
      expect(subject).to be_file
    end
  end

  describe command('/usr/local/bin/reattach-to-user-namespace ls') do
    it 'exits successfully' do
      expect(subject.exit_status).to eq(0)
    end
  end

  describe command('/usr/local/bin/brew list reattach-to-user-namespace') do
    it 'exits unsuccessfully' do
      expect(subject.exit_status).to_not eq(0)
    end
  end
end
