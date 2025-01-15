# frozen_string_literal: true

module DigitalScriptorium
  # Base transformer class providing a common interface for all transformers.
  class InstitutionClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    PREFIX = 'institution'

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: HOLDING_INSTITUTION_IN_AUTHORITY_FILE)
    end
  end
end
