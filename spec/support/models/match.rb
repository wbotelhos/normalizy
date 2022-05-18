# frozen_string_literal: true

class Match < ActiveRecord::Base
  normalizy :alone
  normalizy :downcase_field, with: :downcase
  normalizy :trim_side_left, with: { trim: { side: :left } }
  normalizy :trim_side_left_array, with: [{ trim: { side: :left } }]
  normalizy :downcase_field_array, with: [:downcase]
end
