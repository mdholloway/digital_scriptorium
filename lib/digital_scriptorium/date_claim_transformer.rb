# frozen_string_literal: true

require 'time'

module DigitalScriptorium
  # Special-purpose transformer for date (P23) claims
  class DateClaimTransformer
    include PropertyId

    def self.transform(claim, export_hash, config)
      solr_props = ClaimTransformer.transform(claim, export_hash, config)
      return solr_props unless claim.qualifiers

      century = claim.qualifier_by_property_id(CENTURY).time_value
      earliest = claim.qualifier_by_property_id(EARLIEST_DATE).time_value
      latest = claim.qualifier_by_property_id(LATEST_DATE).time_value

      solr_props['century_int'] = [Time.parse(century).year] unless century.nil?
      solr_props['earliest_int'] = [Time.parse(earliest).year] unless earliest.nil?
      solr_props['latest_int'] = [Time.parse(latest).year] unless latest.nil?

      solr_props
    end
  end
end
