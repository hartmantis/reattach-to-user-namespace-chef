# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'reattach-to-user-namespace::default' do
  %i(source version).each { |a| let(a) { nil } }
  let(:platform) { { platform: 'mac_os_x', version: '10.10' } }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      %i(source version).each do |a|
        unless send(a).nil?
          node.normal['reattach_to_user_namespace']['app'][a] = send(a)
        end
      end
    end
  end
  let(:converge) { runner.converge(described_recipe) }

  context 'all default attributes' do
    cached(:chef_run) { converge }

    it 'installs RtUN' do
      expect(chef_run).to install_reattach_to_user_namespace_app('default')
        .with(source: :homebrew, version: nil)
    end
  end

  context 'an overridden source attribute' do
    let(:source) { :direct }
    cached(:chef_run) { converge }

    it 'installs RtUN' do
      expect(chef_run).to install_reattach_to_user_namespace_app('default')
        .with(source: :direct, version: nil)
    end
  end

  context 'an overridden version attribute' do
    let(:version) { '1.2.3' }
    cached(:chef_run) { converge }

    it 'installs RtUN' do
      expect(chef_run).to install_reattach_to_user_namespace_app('default')
        .with(source: :homebrew, version: '1.2.3')
    end
  end
end
