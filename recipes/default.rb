#
# Cookbook Name:: vim_config
# Recipe:: default
#
# Copyright 2011, Nils Landt
#
# All rights reserved - Do Not Redistribute
#

node.set["vim_config"]["config_file_path"] = ::File.join(node["vim_config"]["installation_dir"], node["vim_config"]["config_file_name"])
node.set["vim_config"]["config_dir"] = ::File.join(node["vim_config"]["installation_dir"], "config.d")

if node["vim_config"]["force_update"]
  [node["vim_config"]["config_dir"], node["vim_config"]["bundle_dir"]].each do |dir|
    directory dir do
      action :delete
      recursive true
    end
  end
end

directory node["vim_config"]["bundle_dir"] do
  owner node["vim_config"]["owner"]
  group node["vim_config"]["owner_group"]
  mode "0755"
  action :create
end

# install a plugin manager
include_recipe "vim_config::_plugin_manager_#{ node["vim_config"]["plugin_manager"] }"

# manage config file(s)
include_recipe "vim_config::_config"

node["vim_config"]["bundles"]["git"].each do |bundle|
  vim_config_git bundle do
    action :create
  end
end

node["vim_config"]["bundles"]["hg"].each do |bundle|
  vim_config_mercurial bundle do
    action :create
  end
end

node["vim_config"]["bundles"]["vim"].each do |name, version|
  vim_config_vim name do
    version version
    action :create
  end
end
