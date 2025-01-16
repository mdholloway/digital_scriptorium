# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for physical description (P29) claims.
  class PhysicalDescriptionClaimTransformer < BaseClaimTransformer
    PREFIX = 'physical_description'

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
