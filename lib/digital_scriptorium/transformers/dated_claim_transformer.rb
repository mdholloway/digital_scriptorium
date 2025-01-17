# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for dated? (P26) claims.
  class DatedClaimTransformer < BaseClaimTransformer
    attr_reader :export_hash

    def initialize(claim, export_hash, **kwargs)
      super(claim, **kwargs)
      @export_hash = export_hash
    end

    def facet_values
      [export_hash[claim.entity_id_value]&.label('en')].compact
    end
  end
end
