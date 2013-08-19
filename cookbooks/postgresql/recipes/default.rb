#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# PostgreSQL RPM Repository（本家のリポジトリ）の追加
bash 'Add_PostgreSQL_rpm' do
  code <<-EOF
#wget http://yum.postgresql.org/9.2/redhat/rhel-5.9-x86_64/pgdg-centos92-9.2-6.noarch.rpm
sudo wget http://yum.postgresql.org/9.2/redhat/rhel-5.9-i386/pgdg-centos92-9.2-6.noarch.rpm
sudo rm -f /tmp/pgdg-cenTos92*
sudo mv pgdg-centos92-9.2-6.noarch.rpm /tmp/.
sudo rpm -ivh /tmp/pgdg-centos92-9.2-6.noarch.rpm
EOF
ignore_failure true
end 

# パッケージのインストール
%w{postgresql92-server}.each do |pkg|
  package pkg do
    action :install
  end
end

# .bash_profileに変数追加(su - postgres)
cookbook_file '/var/lib/pgsql/.bash_profile' do
  source '.bash_profile'
  owner 'postgres'
  group 'postgres'
  mode 0644
end

# データベースクラスタの初期化(su - postgres)
bash 'Initializing_database_cluster' do
  code <<-EOF
sudo -u postgres /usr/pgsql-9.2/bin/initdb --no-locale -D /var/lib/pgsql/9.2/data -E UTF-8
EOF
end

# postgresql.confの設定変更(su - postgres)
cookbook_file '/var/lib/pgsql/9.2/data/postgresql.conf' do
  source 'postgresql.conf'
  owner 'postgres'
  group 'postgres'
  mode 0644
end

# syslogへの出力設定
bash 'creating_directory' do
  code <<-EOF
mkdir -p /var/log/postgres
chown postgres:postgres /var/log/postgres
EOF
end

# syslog.confの編集
cookbook_file '/etc/syslog.conf' do
  source 'syslog.conf'
  owner 'root'
  group 'root'
  mode 0644
end

# vi syslogにpostgresqlのディレクトリも追加
cookbook_file '/etc/logrotate.d/syslog' do
  source 'syslog'
  owner 'root'
  group 'root'
  mode 0644
end

# syslogの再起動
bash 'Restart_syslog' do
  code <<-EOF
/etc/init.d/syslog restart
EOF
end

# 自動起動の設定
bash 'Setting_automatic_start' do
  code <<-EOF
/sbin/chkconfig postgresql-9.2 on
/etc/init.d/postgresql-9.2 start
EOF
end
