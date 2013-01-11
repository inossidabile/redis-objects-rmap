require 'redis/objects/rmap'
require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
ActiveRecord::Migration.create_table :foos do |t|
  t.string :name
end

RSpec.configure do |config|
end