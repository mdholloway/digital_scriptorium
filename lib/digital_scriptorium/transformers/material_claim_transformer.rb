# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for material (P30) claims.
  class MaterialClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    PREFIX = 'material'
    AUTHORITY_ID = MATERIAL_IN_AUTHORITY_FILE

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: AUTHORITY_ID)
    end
  end
end
