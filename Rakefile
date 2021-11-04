
def exec(cmd)
  puts cmd
  puts `#{cmd}`
end

namespace :rails do
  desc "Deploy railsapp to staging(Heroku)."
  task :production do
    exec("git subtree push --prefix railsapp staging master")
  end

  desc "Deploy railsapp to production(Heroku)."
  task :production do
    exec("git subtree push --prefix railsapp production master")
  end
end
