# Encoding: UTF-8

require_relative '../spec_helper'

describe 'reattach-to-user-namespace::default::app' do
  describe file('/usr/local/bin/reattach-to-user-namespace') do
    it 'exists' do
      expect(subject).to be_file
    end
  end

  describe command('reattach-to-user-namespace ls') do
    it 'exits successfully' do
      expect(subject.exit_status).to eq(0)
    end
  end

  describe command('brew list reattach-to-user-namespace') do
    it 'exits successfully' do
      expect(subject.exit_status).to eq(0)
    end
  end
end
