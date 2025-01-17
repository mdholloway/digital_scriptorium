# frozen_string_literal: true

require 'time'

module DigitalScriptorium
  # Transformer for production date (P23) claims.
  class DateClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    CENTURY_ALIAS_PATTERN = /^\d{1,2}(st|nd|rd|th) century$/

    def search_values
      super + [canonical_century_label].compact
    end

    def facet_values
      [century_alias].compact
    end

    def solr_props
      super.merge(meta_props)
    end

    def meta_props
      {
        'date_meta' => [claim.data_value]
      }
    end

    def century_item
      export_hash[authority_qualifiers&.first&.entity_id_value]
    end

    def canonical_century_label
      century_item&.label('en')
    end

    def century_alias
      century_item&.aliases_for_language('en')
                  &.select { |term| term.value.match?(CENTURY_ALIAS_PATTERN) }
                  &.first
                  &.value
    end

    def linked_term_for(authority)
      {
        'label' => century_alias,
        'source_url' => external_uri(authority) || wikidata_uri(authority)
      }.compact
    end
  end
end
