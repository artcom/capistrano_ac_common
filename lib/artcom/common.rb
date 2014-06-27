require 'railsless-deploy'

def _cset(name, *args, &block)
  unless exists?(name)
    set(name, *args, &block)
  end
end

# Bootstrap Capistrano instance
configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

configuration.load do

	namespace :ac_common_deploy do
	  task :fix_permissions do
	    sudo "chown -R #{user}:users #{deploy_to}"
	  end
	end
end