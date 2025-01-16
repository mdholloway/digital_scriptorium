# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for genre (P18) and subject (P19) claims.
  class TermClaimTransformer < QualifiedClaimTransformerWithFacetFallback
    include PropertyId

    PREFIX = 'term'
    AUTHORITY_ID = TERM_IN_AUTHORITY_FILE

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: AUTHORITY_ID)
    end
  end
end
