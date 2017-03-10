# encoding: utf-8
# frozen_string_literal: true

require_relative '../reattach_to_user_namespace_app'

shared_context 'resources::reattach_to_user_namespace_app::mac_os_x' do
  include_context 'resources::reattach_to_user_namespace_app'

  let(:platform) { 'mac_os_x' }

  shared_examples_for 'any MacOS platform' do
    it_behaves_like 'any platform'

    context 'the :install action' do
      include_context description

      context 'all default properties' do
        include_context description

        it 'includes the homebrew default recipe' do
          expect(chef_run).to include_recipe('homebrew')
        end

        it 'installs RtUN via Homebrew' do
          expect(chef_run).to install_homebrew_package(
            'reattach-to-user-namespace'
          )
        end
      end

      context 'an overridden source property (:direct)' do
        include_context description

        context 'not already installed' do
          include_context description

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
          include_context description

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
      include_context description

      context 'all default properties' do
        include_context description
      end

      context 'an overridden source property (:direct)' do
        include_context description

        context 'not already installed' do
          include_context description

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
          include_context description

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
          include_context description

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
      include_context description

      context 'all default properties' do
        include_context description

        it 'includes the homebrew default recipe' do
          expect(chef_run).to include_recipe('homebrew')
        end

        it 'removes RtUN via Homebrew' do
          expect(chef_run).to remove_homebrew_package(
            'reattach-to-user-namespace'
          )
        end
      end

      context 'an overridden source property (:direct)' do
        include_context description

        context 'already installed' do
          include_context description

          it 'removes the RtUN app' do
            f = '/usr/local/bin/reattach-to-user-namespace'
            expect(chef_run).to delete_file(f)
          end
        end

        context 'not already installed' do
          include_context description

          it 'does not remove the RtUN app' do
            f = '/usr/local/bin/reattach-to-user-namespace'
            expect(chef_run).to_not delete_file(f)
          end
        end
      end
    end
  end
end
