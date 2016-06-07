# Encoding: UTF-8

include_recipe 'reattach-to-user-namespace'

app_attrs = node['reattach_to_user_namespace']['app']

reattach_to_user_namespace_app 'defaultier' do
  source app_attrs['source'] unless app_attrs['source'].nil?
  action :remove
end
