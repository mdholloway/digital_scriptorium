# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for acknowledgements (P32) claims.
  class NoteClaimTransformer < BaseClaimTransformer
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
