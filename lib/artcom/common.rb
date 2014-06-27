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

	# --------------------------------------------
	# Task hooks
	# --------------------------------------------
	after 'deploy:setup',  'ac_common_deploy:fix_permissions' 

	namespace :ac_common_deploy do

	# fixes annoying habit of capistrano to create root owned project directory
	# but without use_sudo we cannot create the project directory since
	# the runner and user are different.
	# use as:
	# after 'deploy:setup', 'misc:fix_permissions'     desc "setup directory structure"


    desc "set all file permission to group: users"
	  task :fix_permissions do
	    sudo "chown -R #{user}:users #{deploy_to}"
	  end
	end
end