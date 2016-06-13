#
# Cookbook Name:: didata-jenkins
# Recipe:: credentials
#
# Author:: Eugene Narciso <eugene.narciso@itaas.dimensiondata.com>
# Copyright 2015, Dimension Data
#
# All rights reserved - Do Not Redistribute
#

require 'openssl'
require 'net/ssh'

##############################
# Add credentials to Jenkins #
##############################

include_recipe 'chef-vault'

# Switch attribute to an array;
# Probably not needed, default attribute is already an array (eg; [ "jenkins", "jenkins-test"])
accounts = node['didata-jenkins']['accounts'].to_a

jenkins_pub_data_bag = node['didata-jenkins']['pub_data_bag']
jenkins_priv_data_bag = node['didata-jenkins']['priv_data_bag']

# Loops through the attribute and add the credentials as global
accounts.each do |user|
  servacct_pub_user_data = data_bag_item(jenkins_pub_data_bag, user)
  servacct_priv_user_data = chef_vault_item(jenkins_priv_data_bag, user)

  key = OpenSSL::PKey::RSA.new(servacct_priv_user_data['private_key'])
  private_key = key.to_pem
  public_key = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"

  node.run_state[:jenkins_private_key] = private_key

  jenkins_user servacct_pub_user_data['id'] do
    full_name servacct_pub_user_data['comment']
    public_keys [public_key]
  end

  jenkins_private_key_credentials servacct_pub_user_data['id'] do
    description servacct_pub_user_data['comment']
    private_key servacct_priv_user_data['private_key']
  end
end