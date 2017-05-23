# frozen_string_literal: true

class ModelNumber < ActiveRecord::Base
  normalizy :number, with: :number
end
