# frozen_string_literal: true

module DigitalScriptorium
  # Base transformer class providing a common interface for all transformers.
  class ShelfmarkClaimTransformer < BaseClaimTransformer

    PREFIX = 'shelfmark'

    def initialize(claim)
      super(PREFIX, claim)
    end

    def display_values
      [claim.data_value]
    end

    def search_values
      [claim.data_value]
    end
  end
end
