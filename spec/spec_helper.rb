require 'logger'
require 'rspec'
require 'database_cleaner'
require 'active_record'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'activerecord-column_metadata'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.configurations = YAML::load_file(File.dirname(__FILE__) + '/database.yml')
ActiveRecord::Base.establish_connection(ENV['DB'] || :postgresql)

#ActiveRecord::Base.silence do
#  ActiveRecord::Migration.verbose = false
#end

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
