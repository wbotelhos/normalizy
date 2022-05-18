# frozen_string_literal: true

class Alias < ActiveRecord::Base
  normalizy :email, with: :email
  normalizy :with_arg_field, with: :with_arg
  normalizy :with_inline_arg_field, with: { with_inline_arg: { side: :left } }
end
