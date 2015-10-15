namespace :db do 
  namespace :development do 
    task :refresh do 
      Rails.env = 'development'
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:populate'].invoke
    end
  end
end