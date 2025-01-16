# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for converting qualified claims of Digital Scriptorium items into Solr fields
  # with a fallback to the value as-recorded for the facet field.
  class QualifiedClaimTransformerWithFacetFallback < QualifiedClaimTransformer
    def facet_values
      super.any? ? super : [claim.data_value]
    end
  end
end
