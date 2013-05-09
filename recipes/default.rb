#
# Cookbook Name:: cookbooks-nagios-nrpe
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory node.default[:nagios][:src_temp_path] do
        action :delete
	recursive true
end


directory node.default[:nagios][:src_temp_path] do
	action :create
	#递归创建
	recursive true
end

execute "复制tar到tmp路径" do
	command """
		cd #{node[:nagios][:tarball_path]};
		cp * #{node[:nagios][:src_temp_path]} -rf;
		cd #{node[:nagios][:src_temp_path]};
		tar -xzvf nagios-plugins.tar.gz;
		tar -xzvf nrpe.tar.gz;
		chmod -R +x *;
	"""
end

execute "安装nagios_plugins" do
        command """
		cd #{node[:nagios][:src_temp_path]}/nagios-plugins/;
		./configure --prefix=#{node[:nagios][:install_nagios_path]};
		make&&make install;
        """
end

package "libssl-dev" do
  action :install
end

execute "解决libssl与nagios-nrpe lib 问题" do
	command """
		ln -fs /usr/lib/x86_64-linux-gnu/libssl.so /usr/lib/libssl.so;
	"""
end

execute "安装nagios_nrpe" do
        command """
                cd #{node[:nagios][:src_temp_path]}/nrpe/;
		./configure --prefix=#{node[:nagios][:install_nagios_path]} --with-nrpe-user=root --with-nrpe-group=root --with-nagios-user=root --with-nagios-group=root;
		make all;make install-plugin;make install-daemon;make install-daemon-config;
        """
end

template "#{node[:nagios][:install_nagios_path]}/etc/nrpe.cfg" do
  source "nrpe.cfg.erb"
  variables(
    :nagios_master_ip => node[:nagios][:nagios_master_ip]
  )
end
