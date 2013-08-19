#
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# パッケージのインストール
%w{java-1.7.0-openjdk}.each do |pkg|
  package pkg do
    action :install
  end
end

