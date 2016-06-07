# Encoding: UTF-8

execute 'brew uninstall reattach-to-user-namespace' do
  only_if 'which brew && brew list reattach-to-user-namespace'
end
file '/usr/local/bin/reattach-to-user-namespace' do
  action :delete
end

include_recipe 'reattach-to-user-namespace'

app_attrs = node['reattach_to_user_namespace']['app']

reattach_to_user_namespace_app 'defaultier' do
  source app_attrs['source'] unless app_attrs['source'].nil?
  action :remove
end
