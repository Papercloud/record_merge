#removes the username and password fields from database.yml
remove_file "#{ENV['RAILS_ROOT']}/config/database.yml"
copy_file File.expand_path('../../support/database.yml'), "#{ENV['RAILS_ROOT']}/config/database.yml"

rake "db:drop:all"
rake "db:create:all"

generate :model, 'test_model name:string email:string relation2_id:integer'
generate :model, 'relation1 test_model_id:integer'
generate :model, 'relation2 data:string'
generate :migration, 'create_relation2s_test_models test_model_id:integer relation2_id:integer'

gem_dir = File.expand_path('..',File.dirname(__FILE__))

# Finalise
rake "db:migrate"
rake "db:test:prepare"