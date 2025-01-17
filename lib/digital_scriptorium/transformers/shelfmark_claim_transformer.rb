# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for shelfmark (P8) claims.
  class ShelfmarkClaimTransformer < BaseClaimTransformer
    def initialize(claim, _, **kwargs)
      super(claim, **kwargs)
    end

    def display_values
      [display_value(claim.data_value)]
    end

    def search_values
      [claim.data_value]
    end
  end
end
