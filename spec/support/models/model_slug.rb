# frozen_string_literal: true

class ModelSlug < ActiveRecord::Base
  normalizy :permalink, with: :slug
  normalizy :title, with: { slug: { to: :slug } }
end
