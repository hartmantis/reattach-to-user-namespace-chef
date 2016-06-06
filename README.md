Reattach To User Namespace Cookbook
===================================
[![Cookbook Version](https://img.shields.io/cookbook/v/reattach-to-user-namespace.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/RoboticCheese/reattach-to-user-namespace-chef.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/reattach-to-user-namespace-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/reattach-to-user-namespace-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/reattach-to-user-namespace
[travis]: https://travis-ci.org/RoboticCheese/reattach-to-user-namespace-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/reattach-to-user-namespace-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/reattach-to-user-namespace-chef

A Chef cookbook for the reattach-to-user-namespace OS X utility.

Requirements
============

TODO: Describe cookbook dependencies.

Usage
=====

TODO: Describe how to use the cookbook.

Recipes
=======

***default***

Performs an attribute-based installation of RtUN.

Attributes
==========

***default***

The default behavior is to install via `:homebrew`, but this can be overridden
if you wish to install via `:direct` download and compile from GitHub:

    default['reattach_to_user_namespace']['app']['source'] = nil

If desired, a specific version of RtUN can be installed rather than the latest:

    default['reattach_to_user_namespace']['app']['version'] = nil

Resources
=========

***reattach_to_user_namespace***

TODO: Describe each included resource.

Syntax:

    reattach_to_user_namespace 'my_resource' do
        attribute1 'value1'
        action :create
    end

Actions:

| Action  | Description  |
|---------|--------------|
| action1 | Do something |

Attributes:

| Attribute  | Default        | Description          |
|------------|----------------|----------------------|
| attribute1 | `'some_value'` | Do something         |
| action     | `:create`      | Action(s) to perform |

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@hartman.io>

Copyright 2016, Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
