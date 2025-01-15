# frozen_string_literal: true

module DigitalScriptorium
  # Base transformer class providing a common interface for all transformers.
  class DateClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    PREFIX = 'date'

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: PRODUCTION_CENTURY_IN_AUTHORITY_FILE)
    end

    def extra_props
      { 'date_meta' => [@claim.data_value] }
    end
  end
end
