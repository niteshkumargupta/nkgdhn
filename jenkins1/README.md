didata-jenkins Cookbook
=======================
Manages Master and Slave Jenkins nodes 

Requirements
------------
#### Platforms
- Debian, Ubuntu
- CentOS, Red Hat, Fedora

Usage
-----
The `master` recipe installs & configure jenkins via jenkins community cookbook, installs Apache2 and configure reverse proxy. Use roles to override attributes as needed, see attributes section.

```json
{
  "name": "jenkins-master",
  "description": "Test install & configure master Jenkins node",
  "json_class": "Chef::Role",
  "default_attributes": {},
  "override_attributes": {
    "jenkins": {
      "master": {
        "listen_address": "127.0.0.1"
      }
    },
    "didata-jenkins": {
      "loglevel": "debug"
    }
  },
  "chef_type": "role",
  "run_list": [
    "recipe[didata-jenkins::master]",
    "recipe[didata-jenkins::credentials]"
  ],
  "env_run_lists": {}
}
```

The `credentials` recipe configures global credentials for Jenkins by looping through the array set in the  `node['didata-jenkins']['account']` attributes. See attributes section for more details.

The `slave` recipe configures the slave node in Jenkins, actual slave nodes will need to have proper credentials configured separately using a different cookbook/recipe (eg; `didata-base` cookbook).

Attributes
----------
`default['didata-jenkins']['pub_data_bag']` Public data bag to search, default `users`. The `credentials` recipe leverage this data bag to pull user data.

`default['didata-jenkins']['priv_data_bag']` Private data bag to search, default `private_keys`. The `credentials` recipe leverage this data bag to pull private data such as private keys, md5 or even clear text password. Data bag must be encrypted using chef-vault.

`default['didata-jenkins']['host_data_bag']` Host data bag to search slave hosts data, default `hosts`. Specifically used by the `slave` recipe to pull host specific data.

`default['didata-jenkins']['accounts']` Must set this as an array regardless if there's 1 or more accounts (eg; ["jenkins"]). `credentials` recipe will loop through the accounts and configure it properly in jenkins. Default values `["jenkins", "jenkins-test"]`.

`default['didata-jenkins']['plugins']` An array of plugins to be installed in Jenkins. Default values `[ 'nuget', 'github-oauth', 'ghprb', 'github', 'github-api' ]`. NOTE: this must be set to array regardless if it's just 1.

Contributing
------------
Use the git-flow process: <br>
http://yakiloo.com/getting-started-git-flow/ <br>
https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow <br>

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Author(s)
-------------------
Author: Eugene Narciso (<eugene.narciso@itaas.dimensiondata.com>)
```text
Copyright:: 2015, Dimension Data
All rights reserved
```
