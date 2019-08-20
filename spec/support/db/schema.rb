# frozen_string_literal: true

ActiveRecord::Base.establish_connection adapter: :sqlite3, database: ':memory:'

ActiveRecord::Schema.define(version: 0) do
  create_table :aliases do |t|
    t.string :email
    t.string :with_arg_field
    t.string :with_inline_arg_field
  end

  create_table :matches do |t|
    t.string :alone
    t.string :downcase_field
    t.string :trim_side_left
    t.string :downcase_field_array
  end

  create_table :models do |t|
    t.string :none
    t.string :default
    t.string :block
    t.string :symbol
    t.string :array_symbol
    t.string :array_symbols
    t.string :hash_no_args
    t.string :hash_with_args
    t.string :module_one_arg
    t.string :module_two_args
    t.string :module_and_block
    t.string :method_with_no_options_field
    t.string :method_with_options_field
    t.string :native
    t.string :multiple
  end

  create_table :model_dates do |t|
    t.datetime :date
    t.datetime :date_format
    t.datetime :date_time_zone
  end

  create_table :model_moneys do |t|
    t.string  :text
    t.string  :cents_type
    t.integer :cast_to_i
    t.decimal :cast_to_d
    t.float   :cents_type_and_cast_to_f
    t.integer :cents_type_and_cast_to_i
  end

  create_table :model_numbers do |t|
    t.string :number
  end

  create_table :model_percents do |t|
    t.string  :text
    t.string  :cents_type
    t.integer :cast_to_i
    t.decimal :cast_to_d
    t.float   :cents_type_and_cast_to_f
    t.integer :cents_type_and_cast_to_i
  end

  create_table :model_slugs do |t|
    t.string :permalink
    t.string :slug
    t.string :title
  end

  create_table :model_strips do |t|
    t.string :strip
    t.string :strip_side_both
    t.string :strip_side_left
    t.string :strip_side_right
  end

  create_table :rules do |t|
    t.string :name
  end
end
