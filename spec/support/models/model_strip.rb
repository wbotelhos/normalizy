# frozen_string_literal: true

class ModelStrip < ActiveRecord::Base
  normalizy :strip, with: :strip
  normalizy :strip_side_both, with: { strip: { side: :both } }
  normalizy :strip_side_left, with: { strip: { side: :left } }
  normalizy :strip_side_right, with: { strip: { side: :right } }
end
