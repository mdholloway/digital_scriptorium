# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for converting qualified claims of Digital Scriptorium items into Solr fields.
  class LanguageClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    PREFIX = 'language'

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: LANGUAGE_IN_AUTHORITY_FILE)
    end
  end
end
