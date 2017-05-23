# frozen_string_literal: true

class ModelPercent < ActiveRecord::Base
  normalizy :text                    , with: :percent
  normalizy :cents_type              , with: { percent: { type: :cents } }
  normalizy :cast_to_i               , with: { percent: { cast: :to_i } }
  normalizy :cast_to_d               , with: { percent: { cast: :to_d } }
  normalizy :cents_type_and_cast_to_f, with: { percent: { cast: :to_f, type: :cents } }
  normalizy :cents_type_and_cast_to_i, with: { percent: { cast: :to_i, type: :cents } }
end
