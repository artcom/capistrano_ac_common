# Capistrano2 differentiator
load 'deploy' if respond_to?(:namespace)

# Required gems/libraries
require 'rubygems'
require 'fileutils'
begin
  require 'capistrano/ext/multistage' # gem install capistrano-ext
rescue LoadError
  puts "'capistrano-ext' gem is required on the local machine"
end

begin
  require 'railsless-deploy'
rescue LoadError
  puts "'railsless-deploy' gem is required on the local machine"
end


configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

configuration.load do

  # Load library
  require 'artcom/common'
  require 'artcom/linux'
end
