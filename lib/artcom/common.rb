require 'railsless-deploy'

def _cset(name, *args, &block)
  unless exists?(name)
    set(name, *args, &block)
  end
end

# I got tired of uploading to /tmp then moving to the correct location, so these two convenience methods will save you a lot of time in the long run.
 
# Helper method to upload to /tmp then use sudo to move to correct location.
def put_sudo(data, to)
  filename = File.basename(to)
  to_directory = File.dirname(to)
  put data, "/tmp/#{filename}"
  run "#{sudo} mv /tmp/#{filename} #{to_directory}"
end
 
# Helper method to create ERB template then upload using sudo privileges (modified from rbates)
def template_sudo(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put_sudo ERB.new(erb).result(binding), to
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
	    sudo "chown -R #{user}:#{user} #{deploy_to}"
	  end
	end
end