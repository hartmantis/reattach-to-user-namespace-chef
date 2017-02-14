require_relative '../../../spec_helper'
require_relative '../../../../libraries/helpers_app'

describe 'resource_reattach_to_user_namespace_app::mac_os_x::10_10' do
  let(:name) { 'default' }
  let(:latest_version?) { '1.2.3' }
  %i(installed? installed_version?).each { |i| let(i) { nil } }
  let(:installed_version?) { nil }
  %i(source version action).each do |p|
    let(p) { nil }
  end
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'reattach_to_user_namespace_app',
      platform: 'mac_os_x',
      version: '10.10'
    ) do |node|
      %i(name source version action).each do |p|
        unless send(p).nil?
          node.set['resource_reattach_to_user_namespace_app_test'][p] = send(p)
        end
      end
    end
  end
  let(:converge) do
    runner.converge('resource_reattach_to_user_namespace_app_test')
  end

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

  context 'the default action (:install)' do
    let(:action) { nil }

    context 'the default source (:homebrew)' do
      cached(:chef_run) { converge }

      it 'installs RtUN via Homebrew' do
        expect(chef_run).to install_homebrew_package(
          'reattach-to-user-namespace'
        )
      end
    end

    context 'the :direct source' do
      let(:source) { :direct }

      context 'not already installed' do
        let(:installed?) { false }
        cached(:chef_run) { converge }

        it 'downloads the .zip file from GitHub' do
          expect(chef_run).to create_remote_file(
            "#{Chef::Config[:file_cache_path]}/rtun-v1.2.3.zip"
          ).with(source: 'https://github.com/ChrisJohnsen/' \
                         'tmux-MacOSX-pasteboard/archive/v1.2.3.zip')
        end

        it 'extracts the .zip file' do
          expect(chef_run).to run_execute('Extract RtUN zip file').with(
            command: "unzip -j -d #{Chef::Config[:file_cache_path]}/" \
                     "rtun-v1.2.3 -o #{Chef::Config[:file_cache_path]}/" \
                     'rtun-v1.2.3.zip'
          )
        end

        it 'compiles RtUN' do
          expect(chef_run).to run_execute('Compile RtUN from source').with(
            command: 'make',
            cwd: "#{Chef::Config[:file_cache_path]}/rtun-v1.2.3"
          )
        end

        it 'moves the compiled app into place' do
          expect(chef_run).to create_remote_file(
            '/usr/local/bin/reattach-to-user-namespace'
          ).with(
            source: "file://#{Chef::Config[:file_cache_path]}/rtun-v1.2.3/" \
                    'reattach-to-user-namespace',
            mode: '0755'
          )
        end
      end

      context 'already installed' do
        let(:installed?) { true }
        let(:installed_version?) { '1.2.0' }
        cached(:chef_run) { converge }

        it 'does not download the .zip file from GitHub' do
          expect(chef_run).to_not create_remote_file(
            "#{Chef::Config[:file_cache_path]}/rtun-v1.2.3.zip"
          )
        end

        it 'does not extract the .zip file' do
          expect(chef_run).to_not run_execute('Extract RtUN zip file')
        end

        it 'does not compile RtUN' do
          expect(chef_run).to_not run_execute('Compile RtUN from source')
        end

        it 'does not move the compiled app into place' do
          expect(chef_run).to_not create_remote_file(
            '/usr/local/bin/reattach-to-user-namespace'
          )
        end
      end
    end
  end

  context 'the :upgrade action' do
    let(:action) { :upgrade }

    context 'the default source (:homebrew)' do
      cached(:chef_run) { converge }
    end

    context 'the :direct source' do
      let(:source) { :direct }

      context 'not already installed' do
        let(:installed?) { false }
        cached(:chef_run) { converge }

        it 'downloads the .zip file from GitHub' do
          expect(chef_run).to create_remote_file(
            "#{Chef::Config[:file_cache_path]}/rtun-v1.2.3.zip"
          ).with(source: 'https://github.com/ChrisJohnsen/' \
                         'tmux-MacOSX-pasteboard/archive/v1.2.3.zip')
        end

        it 'extracts the .zip file' do
          expect(chef_run).to run_execute('Extract RtUN zip file').with(
            command: "unzip -j -d #{Chef::Config[:file_cache_path]}/" \
                     "rtun-v1.2.3 -o #{Chef::Config[:file_cache_path]}/" \
                     'rtun-v1.2.3.zip'
          )
        end

        it 'compiles RtUN' do
          expect(chef_run).to run_execute('Compile RtUN from source').with(
            command: 'make',
            cwd: "#{Chef::Config[:file_cache_path]}/rtun-v1.2.3"
          )
        end

        it 'moves the compiled app into place' do
          expect(chef_run).to create_remote_file(
            '/usr/local/bin/reattach-to-user-namespace'
          ).with(
            source: "file://#{Chef::Config[:file_cache_path]}/rtun-v1.2.3/" \
                    'reattach-to-user-namespace',
            mode: '0755'
          )
        end
      end

      context 'already installed' do
        let(:installed?) { true }
        let(:installed_version?) { '1.2.3' }
        cached(:chef_run) { converge }

        it 'does not download the .zip file from GitHub' do
          expect(chef_run).to_not create_remote_file(
            "#{Chef::Config[:file_cache_path]}/rtun-v1.2.3.zip"
          )
        end

        it 'does not extract the .zip file' do
          expect(chef_run).to_not run_execute('Extract RtUN zip file')
        end

        it 'does not compile RtUN' do
          expect(chef_run).to_not run_execute('Compile RtUN from source')
        end

        it 'does not move the compiled app into place' do
          expect(chef_run).to_not create_remote_file(
            '/usr/local/bin/reattach-to-user-namespace'
          )
        end
      end

      context 'installed but in need of an upgrade' do
        let(:installed?) { true }
        let(:installed_version?) { '1.1.0' }
        cached(:chef_run) { converge }

        it 'downloads the .zip file from GitHub' do
          expect(chef_run).to create_remote_file(
            "#{Chef::Config[:file_cache_path]}/rtun-v1.2.3.zip"
          ).with(source: 'https://github.com/ChrisJohnsen/' \
                         'tmux-MacOSX-pasteboard/archive/v1.2.3.zip')
        end

        it 'extracts the .zip file' do
          expect(chef_run).to run_execute('Extract RtUN zip file').with(
            command: "unzip -j -d #{Chef::Config[:file_cache_path]}/" \
                     "rtun-v1.2.3 -o #{Chef::Config[:file_cache_path]}/" \
                     'rtun-v1.2.3.zip'
          )
        end

        it 'compiles RtUN' do
          expect(chef_run).to run_execute('Compile RtUN from source').with(
            command: 'make',
            cwd: "#{Chef::Config[:file_cache_path]}/rtun-v1.2.3"
          )
        end

        it 'moves the compiled app into place' do
          expect(chef_run).to create_remote_file(
            '/usr/local/bin/reattach-to-user-namespace'
          ).with(
            source: "file://#{Chef::Config[:file_cache_path]}/rtun-v1.2.3/" \
                    'reattach-to-user-namespace',
            mode: '0755'
          )
        end
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }

    context 'the default source (:homebrew)' do
      cached(:chef_run) { converge }

      it 'removes RtUN via Homebrew' do
        expect(chef_run).to remove_homebrew_package(
          'reattach-to-user-namespace'
        )
      end
    end

    context 'the :direct source' do
      let(:source) { :direct }

      context 'installed' do
        let(:installed?) { true }
        let(:installed_version) { '1.2.3' }
        cached(:chef_run) { converge }

        it 'removes the RtUN app' do
          f = '/usr/local/bin/reattach-to-user-namespace'
          expect(chef_run).to delete_file(f)
        end
      end

      context 'not installed' do
        let(:installed?) { false }
        cached(:chef_run) { converge }

        it 'does not remove the RtUN app' do
          f = '/usr/local/bin/reattach-to-user-namespace'
          expect(chef_run).to_not delete_file(f)
        end
      end
    end
  end
end
