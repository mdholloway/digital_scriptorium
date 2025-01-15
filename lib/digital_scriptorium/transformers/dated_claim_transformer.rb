# frozen_string_literal: true

module DigitalScriptorium
  # Base transformer class providing a common interface for all transformers.
  class DatedClaimTransformer < BaseClaimTransformer
    PREFIX = 'dated'

    def initialize(claim, export_hash)
      super(claim, prefix: PREFIX)
      @export_hash = export_hash
    end

    def facet_values
      [@export_hash[@claim.entity_id_value]&.label('en')].compact
    end
  end
end
