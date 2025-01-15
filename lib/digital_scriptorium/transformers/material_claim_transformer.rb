# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for converting qualified claims of Digital Scriptorium items into Solr fields.
  class MaterialClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    PREFIX = 'material'

    def initialize(claim, export_hash)
      super(claim, export_hash, prefix: PREFIX, authority_id: MATERIAL_IN_AUTHORITY_FILE)
    end
  end
end
