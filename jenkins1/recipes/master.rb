#
# Cookbook Name:: didata-jenkins
# Recipe:: master
#
# Author:: Eugene Narciso <eugene.narciso@itaas.dimensiondata.com>
# Copyright 2015, Dimension Data
#
# All rights reserved - Do Not Redistribute
#

# Notes:
# * Indepedently create jenkins user w/ uid from data_bag; default "service_accounts"
# * Installs jenkins + dependent package(s)
# * Configure apache2 for reverse proxy from 127.0.0.1:8080 to https://node['fqdn']
# * Determine if signed or self-signed CA

# Per jenkins wiki: https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Red+Hat+distributions
if platform?('centos')
  package 'java-1.8.0-openjdk'
end

include_recipe 'jenkins::master'

# Loop through the node['didata-jenkins']['plugins'] attributes to install plugins
node['didata-jenkins']['plugins'].each do |plugin|
  jenkins_plugin plugin do
    install_deps true
    notifies :restart, 'service[jenkins]'
  end
end

# Install Apache and configure as reverse proxy
include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_rewrite'

# disabling proxy.conf; apache2::mod_proxy & apache2::mod_proxy_http sets proxy.conf to true and sets deny all.
%w{proxy proxy_http}.each do |apache_mod|
  apache_module apache_mod do
    conf false
  end
end

# Load Jenkins site for reverse proxy
cert_file = node['didata-jenkins']['ssl']['cert_file']
priv_file = node['didata-jenkins']['ssl']['key_file']

web_app "jenkins-proxy" do
  template 'jenkins-proxy.conf.erb'
  certificate_file cert_file
  private_file priv_file
end