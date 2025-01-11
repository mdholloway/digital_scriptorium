# frozen_string_literal: true

require 'time'

module DigitalScriptorium
  # Special-purpose transformer for date (P23) claims
  class DateClaimTransformer
    include PropertyId

    def self.transform(claim, export_hash, config)
      solr_props = QualifiedClaimTransformer.transform(claim, export_hash, config)
      return solr_props unless claim.qualifiers

      century = time_value_from_qualifier(claim, CENTURY)
      earliest = time_value_from_qualifier(claim, EARLIEST_DATE)
      latest = time_value_from_qualifier(claim, LATEST_DATE)

      solr_props['date_meta'] = [claim.data_value]
      solr_props['century_int'] = [parse_year(century)]
      solr_props['earliest_int'] = [parse_year(earliest)]
      solr_props['latest_int'] = [parse_year(latest)]

      solr_props
    end

    def self.time_value_from_qualifier(claim, property_id)
      claim.qualifiers_by_property_id(property_id)&.first&.time_value
    end

    # Wikibase date format "resembling ISO 8601": +YYYY-MM-DDT00:00:00Z
    # https://www.wikidata.org/wiki/Help:Dates#Time_datatype
    def self.parse_year(date)
      Time.iso8601(date[1..]).year
    end
  end
end
