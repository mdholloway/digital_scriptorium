# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for converting qualified claims of Digital Scriptorium items into Solr fields.
  class PlaceClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    PREFIX = 'place'

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: PLACE_IN_AUTHORITY_FILE)
    end
  end
end
