# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for title (P10) claims.
  class TitleClaimTransformer < QualifiedClaimTransformerWithFacetFallback
    include PropertyId

    PREFIX = 'title'
    AUTHORITY_ID = STANDARD_TITLE

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: AUTHORITY_ID)
    end
  end
end
