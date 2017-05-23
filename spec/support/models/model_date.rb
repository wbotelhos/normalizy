# frozen_string_literal: true

class ModelDate < ActiveRecord::Base
  normalizy :date          , with: :date
  normalizy :date_format   , with: { date: { format: '%y/%m/%d' } }
  normalizy :date_time_zone, with: { date: { time_zone: 'Brasilia' } }
end
