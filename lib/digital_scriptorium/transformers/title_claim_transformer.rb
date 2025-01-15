# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for converting qualified claims of Digital Scriptorium items into Solr fields.
  class TitleClaimTransformer < QualifiedClaimTransformerWithFacetFallback
    include PropertyId

    PREFIX = 'title'

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: STANDARD_TITLE)
    end
  end
end
