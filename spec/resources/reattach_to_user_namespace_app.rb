# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::reattach_to_user_namespace_app' do
  include_context 'resources'

  let(:resource) { 'reattach_to_user_namespace_app' }
  %w(source version).each { |p| let(p) { nil } }
  let(:properties) { { source: source, version: version } }
  let(:name) { 'default' }

  %i(installed? installed_version?).each { |i| let(i) { nil } }
  let(:latest_version?) { '1.2.3' }
  let(:installed_version?) { nil }

  before(:each) do
    allow(Kernel).to receive(:load).and_call_original
    allow(Kernel).to receive(:load)
      .with(%r{reattach-to-user-namespace/libraries/helpers_app\.rb})
      .and_return(true)
    %i(latest_version? installed? installed_version?).each do |m|
      allow(ReattachToUserNamespace::Helpers::App).to receive(m)
        .and_return(send(m))
    end
    stub_command('which git').and_return('git')
  end

  shared_context 'the :install action' do
  end

  shared_context 'the :upgrade action' do
    let(:action) { :upgrade }
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'all default properties' do
  end

  shared_context 'an overridden source property (:direct)' do
    let(:source) { :direct }
  end

  shared_context 'not already installed' do
    let(:installed?) { false }
  end

  shared_context 'already installed' do
    let(:installed?) { true }
    let(:installed_version?) { '1.2.3' }
  end

  shared_context 'installed but in need of an upgrade' do
    let(:installed?) { true }
    let(:installed_version?) { '1.1.0' }
  end

  shared_examples_for 'any platform' do
    context 'the :install action' do
      include_context description

      it 'installs a reattach_to_user_namespace_app resource' do
        expect(chef_run).to install_reattach_to_user_namespace_app(name)
      end
    end

    context 'the :upgrade action' do
      include_context description

      it 'upgrades a reattach_to_user_namespace_app resource' do
        expect(chef_run).to upgrade_reattach_to_user_namespace_app(name)
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes a reattach_to_user_namespace_app resource' do
        expect(chef_run).to remove_reattach_to_user_namespace_app(name)
      end
    end
  end
end
