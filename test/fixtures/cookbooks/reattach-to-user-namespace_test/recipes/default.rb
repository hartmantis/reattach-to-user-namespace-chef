# Encoding: UTF-8

execute 'brew uninstall reattach-to-user-namespace' do
  only_if 'which brew && brew list reattach-to-user-namespace'
end
file '/usr/local/bin/reattach-to-user-namespace' do
  action :delete
end

include_recipe 'reattach-to-user-namespace'
