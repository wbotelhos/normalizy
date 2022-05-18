# frozen_string_literal: true

class Model < ActiveRecord::Base
  normalizy :default

  normalizy :block, with: ->(value) { value.upcase }
  normalizy :symbol, with: :squish
  normalizy :array_symbol, with: [:squish]
  normalizy :array_symbols, with: %i[downcase squish]
  normalizy :hash_no_args, with: { squish: { ignored: true } }
  normalizy :hash_with_args, with: { strip: { side: :left } }
  normalizy :module_one_arg, with: Normalizy::Filters::Blacklist
  normalizy :module_two_args, with: Normalizy::Filters::Info
  normalizy :module_and_block, with: :blacklist, &->(value) { value.upcase }
  normalizy :method_with_no_options_field, with: :method_with_no_options
  normalizy :method_with_options_field, with: { method_with_options: { key: :value } }
  normalizy :native, with: :split
  normalizy :multiple, with: :downcase
  normalizy :multiple, with: :titleize

  def method_with_options(input, options = {})
    [input, options].join ', '
  end

  def method_with_no_options(input)
    input
  end
end
