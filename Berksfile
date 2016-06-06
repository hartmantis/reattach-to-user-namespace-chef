# Encoding: UTF-8

source 'https://supermarket.chef.io'

metadata

group :unit do
  cookbook 'resource_reattach_to_user_namespace_app_test',
           path: 'spec/support/cookbooks/' \
                 'resource_reattach_to_user_namespace_app_test'
end

group :integration do
  cookbook 'reattach-to-user-namespace_test',
           path: 'test/fixtures/cookbooks/reattach-to-user-namespace_test'
end
