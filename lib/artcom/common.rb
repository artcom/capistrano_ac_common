def _cset(name, *args, &block)
  unless exists?(name)
    set(name, *args, &block)
  end
end

namespace :ac_common_deploy do
  task :fix_permissions do
    sudo "chown -R #{user}:users #{deploy_to}"
  end
end