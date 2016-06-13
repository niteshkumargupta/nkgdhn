#
# Cookbook Name:: didata-jenkins
# Recipe:: slave
#
# Author:: Eugene Narciso <eugene.narciso@itaas.dimensiondata.com>
# Copyright 2015, Dimension Data
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef-vault'

user_creds =  node['didata-jenkins']['slave_user_creds']
pub_data_bag = node['didata-jenkins']['pub_data_bag']
priv_data_bag = node['didata-jenkins']['priv_data_bag']
host_data_bag = node['didata-jenkins']['host_data_bag']

user_data = data_bag_item(pub_data_bag, user_creds)
priv_data = chef_vault_item(priv_data_bag, user_creds)

key = OpenSSL::PKey::RSA.new(priv_data['private_key'])
private_key = key.to_pem

node.run_state[:jenkins_private_key] = private_key

data_bag(host_data_bag).each do |host|
  host_data = data_bag_item(host_data_bag, host)

  case host_data['method']
    when 'ssh'
      jenkins_ssh_slave host_data['id'] do
        # SSH specific attributes
        user user_data['id']
        credentials user_data['id']
        remote_fs user_data['home_dir']
        host host_data['ip_address']
        executors host_data['executors']
        description host_data['description']
        labels host_data['labels']
        environment(host_data['environment'])
        only_if { ['debian', 'rhel'].include?(node['platform_family']) }
      end
    when 'jnlp'
      remote_fs = "C:\\Users\\#{user_data['id']}"
      # All windows default to jnlp method of connection
      jenkins_windows_slave host_data['id'] do
        user user_data['id']
        password priv_data['passwordclear']
        remote_fs remote_fs
        description host_data['description']
        labels host_data['labels']
        environment(host_data['environment'])
        only_if { node['platform_family'] == 'windows' }
      end
  end
end