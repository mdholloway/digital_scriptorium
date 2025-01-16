# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for acknowledgements (P32) claims.
  class NoteClaimTransformer < BaseClaimTransformer
    PREFIX = 'note'

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
