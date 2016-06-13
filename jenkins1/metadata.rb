name 'didata-jenkins'
maintainer 'Dimension Data'
maintainer_email 'eugene.narciso@itaas.dimensiondata.com'
license 'All rights reserved'
description 'Installs/Configures didata-jenkins'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.2.0'

supports 'ubuntu'
supports 'centos'
supports 'rhel'

depends 'didata-base'
depends 'jenkins'
depends 'apache2'
depends 'chef-vault'
