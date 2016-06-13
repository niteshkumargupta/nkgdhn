#
# Cookbook Name:: didata-jenkins
# Attributes:: default
#
# Author:: Eugene Narciso <eugene.narciso@itaas.dimensiondata.com>
# Copyright 2015, Dimension Data
#
# All rights reserved - Do Not Redistribute
#

# Default values
default['didata-jenkins']['pub_data_bag'] = 'users'
default['didata-jenkins']['priv_data_bag'] = 'private_keys'
default['didata-jenkins']['host_data_bag'] = 'hosts'
default['didata-jenkins']['accounts'] = ['jenkins', 'jenkins-test']
default['didata-jenkins']['plugins'] = [
  'nuget',
  'github-oauth',
  'github',
  'ghprb',
  'github-api',
  'slack',
  'delivery-pipeline-plugin',
  'chef'
]

# Jenkins Slaves attributes
default['didata-jenkins']['slave_user_creds'] = 'jenkins-test'
default['didata-jenkins']['slave_executor'] = 2

# Default Apache2 parameters
default['didata-jenkins']['webmaster_email'] = 'webmaster@example.com'
default['didata-jenkins']['loglevel'] = 'info'

# Default Apache2 paths and files are different between debian & rhel platform_family
case node['platform_family']
  when 'debian'
    default['didata-jenkins']['log_path'] = '/var/log/apache2'
    default['didata-jenkins']['ssl_path'] = '/etc/ssl'
    default['didata-jenkins']['ssl']['cert_file'] = "#{node['didata-jenkins']['ssl_path']}/certs/ssl-cert-snakeoil.pem"
    default['didata-jenkins']['ssl']['key_file'] = "#{node['didata-jenkins']['ssl_path']}/private/ssl-cert-snakeoil.key"
  when 'rhel'
    default['didata-jenkins']['log_path'] = '/var/log/httpd'
    default['didata-jenkins']['ssl_path'] = '/etc/pki/tls'
    default['didata-jenkins']['ssl']['cert_file'] = "#{node['didata-jenkins']['ssl_path']}/certs/localhost.crt"
    default['didata-jenkins']['ssl']['key_file'] = "#{node['didata-jenkins']['ssl_path']}/private/localhost.key"
end
if ::File.exist?("#{node['didata-jenkins']['ssl_path']}/certs/#{node['fqdn']}.crt") & ::File.exist?("#{node['didata-jenkins']['ssl_path']}/private/#{node['fqdn']}.key")
  default['didata-jenkins']['ssl']['cert_file'] = "#{node['didata-jenkins']['ssl_path']}/certs/#{node['fqdn']}.crt"
  default['didata-jenkins']['ssl']['key_file'] = "#{node['didata-jenkins']['ssl_path']}/private/#{node['fqdn']}.key"
end