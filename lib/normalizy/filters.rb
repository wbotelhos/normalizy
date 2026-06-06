# frozen_string_literal: true

module Normalizy
  module Filters
  end
end

Dir["#{File.dirname(__FILE__)}/filters/*.rb"].sort.each { |file| require file }
