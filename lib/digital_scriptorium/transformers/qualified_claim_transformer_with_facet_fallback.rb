# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for converting qualified claims of Digital Scriptorium items into Solr fields.
  class QualifiedClaimTransformerWithFacetFallback < QualifiedClaimTransformer
    def facet_values
      super.any? ? super : [claim.data_value]
    end
  end
end
