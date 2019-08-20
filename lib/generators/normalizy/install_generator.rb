# frozen_string_literal: true

module Normalizy
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'creates an initializer'

    def copy_initializer
      copy_file 'config/initializers/normalizy.rb', 'config/initializers/normalizy.rb'
    end
  end
end
