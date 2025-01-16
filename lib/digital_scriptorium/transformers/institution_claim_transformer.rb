# frozen_string_literal: true

module DigitalScriptorium
  # Base transformer class providing a common interface for all transformers.
  class InstitutionClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    PREFIX = 'institution'
    AUTHORITY_ID = HOLDING_INSTITUTION_IN_AUTHORITY_FILE

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: AUTHORITY_ID)
    end
  end
end
