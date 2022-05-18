# frozen_string_literal: true

class ModelMoney < ActiveRecord::Base
  normalizy :text, with: :money
  normalizy :cents_type, with: { money: { type: :cents } }
  normalizy :cast_to_i, with: { money: { cast: :to_i } }
  normalizy :cast_to_d, with: { money: { cast: :to_d } }
  normalizy :cents_type_and_cast_to_f, with: { money: { cast: :to_f, type: :cents } }
  normalizy :cents_type_and_cast_to_i, with: { money: { cast: :to_i, type: :cents } }
end
