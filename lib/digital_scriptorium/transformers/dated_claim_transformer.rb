# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for dated? (P26) claims.
  class DatedClaimTransformer < BaseClaimTransformer
    attr_reader :export_hash

    def initialize(claim, export_hash = nil, prefix: nil, authority_id: nil)
      super(claim, export_hash, prefix: prefix, authority_id: authority_id)
      @export_hash = export_hash
    end

    def facet_values
      [export_hash[claim.entity_id_value]&.label('en')].compact
    end
  end
end
