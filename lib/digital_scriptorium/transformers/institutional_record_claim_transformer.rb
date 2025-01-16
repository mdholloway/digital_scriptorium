# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for institutional record (P9) claims.
  class InstitutionalRecordClaimTransformer < LinkClaimTransformer
    PREFIX = 'institutional_record'

    def initialize(claim, _)
      super(claim, prefix: PREFIX)
    end
  end
end
