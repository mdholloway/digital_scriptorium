# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for converting qualified claims of Digital Scriptorium items into Solr fields.
  class TermClaimTransformer < QualifiedClaimTransformerWithFacetFallback
    include PropertyId

    PREFIX = 'term'

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: TERM_IN_AUTHORITY_FILE)
    end
  end
end
