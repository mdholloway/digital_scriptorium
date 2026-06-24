# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for acknowledgements (P33) claims.
  class AcknowledgementsClaimTransformer < BaseClaimTransformer
    def display_values
      [display_value(claim.data_value)]
    end
  end
end
