ActiveRecord::Base.establish_connection adapter: :sqlite3, database: ':memory:'

ActiveRecord::Schema.define(version: 0) do
  create_table :cleans do |t|
    t.string :name
  end

  create_table :users do |t|
    t.integer :age
    t.integer :amount
    t.string  :name
  end
end
