name 'composer'
maintainer 'Escape Studios'
maintainer_email 'dev@escapestudios.com'
license 'MIT'
description 'Installs/Configures Composer'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.3.0'

%w( debian ubuntu redhat centos fedora scientific amazon windows ).each do |os|
  supports os
end

depends 'php'

recommends 'windows'

recipe 'composer', 'Installs (if applicable) and self-updates composer.'
recipe 'composer::install', 'Installs composer.'
recipe 'composer::self_update', 'Installs (if applicable) and self-updates composer.'
recipe 'composer::global_configs', 'Sets up global config options via `composer config --global`'

source_url 'https://github.com/escapestudios-cookbooks/composer' if respond_to?(:source_url)
issues_url 'https://github.com/escapestudios-cookbooks/composer/issues' if respond_to?(:issues_url)
