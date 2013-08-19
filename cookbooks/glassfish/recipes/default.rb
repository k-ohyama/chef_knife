#
# Cookbook Name:: glassfish
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# 変数等の設定
package_url = node['glassfish']['package_url']
base_package_filename = File.basename(package_url)
cached_package_filename = "#{Chef::Config[:file_cache_path]}/#{base_package_filename}"
check_proc = Proc.new { ::File.exists?(node['glassfish']['base_dir']) }

remote_file cached_package_filename do
  not_if { check_proc.call }
  source package_url
  mode '0600'
  action :create_if_missing
end

package 'unzip'

bash 'unpack_glassfish' do
  not_if { check_proc.call }
  code <<-EOF
rm -rf /tmp/glassfish
mkdir /tmp/glassfish
cd /tmp/glassfish
unzip -qq #{cached_package_filename}
mkdir -p #{File.dirname(node['glassfish']['base_dir'])}
mv glassfish3 #{node['glassfish']['base_dir']}
chmod -R 0770 #{node['glassfish']['base_dir']}/bin/
chmod -R 0770 #{node['glassfish']['base_dir']}/glassfish/bin/
test -d #{node['glassfish']['base_dir']}
EOF
end

# ファイアーウォールの設定
#bash 'Add_FW_rules' do
#  code <<-EOF
#iptables -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 4848 -j ACCEPT
#/etc/init.d/iptables save
#EOF
#end

#service "iptables" do
#  supports :status => true, :restart => true
#  action [ :enable, :start ]
#end

# 自動起動の設定
cookbook_file "/etc/init.d/glassfish" do
  source "glassfish"
  owner "root"
  group "root"
  mode 0755
end

#service "glassfish" do
#  action [ :enable ]
#end

# GlassFishサーバの起動
bash 'Start_GlassFish_Server' do
  code <<-EOF
chkconfig --add glassfish
/etc/init.d/glassfish start
EOF
end

