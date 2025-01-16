# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for converting qualified claims of Digital Scriptorium items into Solr fields.
  class LanguageClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    PREFIX = 'language'
    AUTHORITY_ID = LANGUAGE_IN_AUTHORITY_FILE

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: AUTHORITY_ID)
    end
  end
end
