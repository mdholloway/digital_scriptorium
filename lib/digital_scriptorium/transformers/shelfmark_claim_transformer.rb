# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for shelfmark (P8) claims.
  class ShelfmarkClaimTransformer < BaseClaimTransformer
    PREFIX = 'shelfmark'

    def initialize(claim, _)
      super(claim, prefix: PREFIX)
    end

    def display_values
      [display_value(claim.data_value)]
    end

    def search_values
      [claim.data_value]
    end
  end
end
