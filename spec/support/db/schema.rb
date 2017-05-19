# frozen_string_literal: true

ActiveRecord::Base.establish_connection adapter: :sqlite3, database: ':memory:'

ActiveRecord::Schema.define(version: 0) do
  create_table :cleans do |t|
    t.string :name
  end

  create_table :users do |t|
    t.datetime :birthday
    t.decimal  :amount, precision: 16, scale: 10
    t.integer  :age
    t.integer  :amount_cents
    t.string   :amount_text
    t.string   :name
  end
end
