#find the tarball path


node.default[:nagios][:install_prefix_path]= "/usr/local"

node.default[:nagios][:nagios_master_ip]="223.4.21.21"

#nrpe 和 nagios 不会在make时候自己创建目录

node.default[:nagios][:install_nagios_path] = node[:nagios][:install_prefix_path]+"/nagios"

node.default[:nagios][:src_temp_path]="#{node[:nagios][:install_prefix_path]}/src/cookbooks-nagios-nrpe"

require 'pathname'
tarball_path = Pathname.new(File.dirname(__FILE__)+"/../files/default/").realpath
#set the tarball path
node.default[:nagios][:tarball_path] = tarball_path
