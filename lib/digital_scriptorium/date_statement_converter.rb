# frozen_string_literal: true

require 'time'

module DigitalScriptorium
  class DateStatementConverter
    include PropertyId

    def self.convert(statement, export_hash, config)
      solr_props = StatementConverter.convert(statement, export_hash, config)
      return solr_props unless statement.qualifiers

      century = statement.qualifier_by_property_id(CENTURY).time_value
      earliest = statement.qualifier_by_property_id(EARLIEST_DATE).time_value
      latest = statement.qualifier_by_property_id(LATEST_DATE).time_value

      solr_props['century_int'] = [Time.parse(century).year] unless century.nil?
      solr_props['earliest_int'] = [Time.parse(earliest).year] unless earliest.nil?
      solr_props['latest_int'] = [Time.parse(latest).year] unless latest.nil?

      solr_props
    end
  end
end
