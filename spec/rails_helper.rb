# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'active_record/railtie'
require 'normalizy'
require 'pry-byebug'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |file| require file }

def offset_in_hours(time_zone)
  TZInfo::Timezone.get(time_zone).current_period.offset.utc_total_offset.to_f / 3600.0
end
