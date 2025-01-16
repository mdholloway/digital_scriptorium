# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for place (P28) claims.
  class PlaceClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    PREFIX = 'place'
    AUTHORITY_ID = PLACE_IN_AUTHORITY_FILE

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: AUTHORITY_ID)
    end
  end
end
