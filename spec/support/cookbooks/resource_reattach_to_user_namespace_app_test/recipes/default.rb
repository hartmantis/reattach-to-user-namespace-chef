# Encoding: UTF-8

attrs = node['resource_reattach_to_user_namespace_app_test']

reattach_to_user_namespace_app attrs['name'] do
  source attrs['source'] unless attrs['source'].nil?
  version attrs['version'] unless attrs['version'].nil?
  action attrs['action'] unless attrs['action'].nil?
end
