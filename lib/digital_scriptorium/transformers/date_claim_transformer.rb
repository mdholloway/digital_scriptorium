# frozen_string_literal: true

require 'time'

module DigitalScriptorium
  # Transformer for production date (P23) claims.
  class DateClaimTransformer < QualifiedClaimTransformer
    include PropertyId

    def solr_props
      super.merge(meta_props).merge(int_props)
    end

    def meta_props
      {
        'date_meta' => [claim.data_value]
      }
    end

    def int_props
      return {} unless claim.qualifiers_by_property_id? CENTURY

      {
        'century_int' => [parse_year(time_value_from_qualifier(CENTURY))]
      }
    end

    def time_value_from_qualifier(property_id)
      claim.qualifiers_by_property_id(property_id)&.first&.time_value
    end

    # Wikibase date format "resembling ISO 8601": +YYYY-MM-DDT00:00:00Z
    # https://www.wikidata.org/wiki/Help:Dates#Time_datatype
    def parse_year(date)
      Time.iso8601(date[1..]).year
    end
  end
end
