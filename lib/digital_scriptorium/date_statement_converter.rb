# frozen_string_literal: true

require 'time'

module DigitalScriptorium
  class DateStatementConverter < StatementConverter
    include PropertyId
    include WikibaseRepresentable::Model::DataValueHelper

    def self.convert(statement, export_hash, config)
      solr_props = super.convert(statement, export_hash, config)
      return solr_props unless statement.qualifiers

      century = time_value_from statement.qualifier_by_property_id(CENTURY)
      earliest = time_value_from statement.qualifier_by_property_id(EARLIEST_DATE)
      latest = time_value_from statement.qualifier_by_property_id(LATEST_DATE)

      solr_props['century_int'] = [Time.parse(century).year] unless century.nil?
      solr_props['earliest_int'] = [Time.parse(earliest).year] unless earliest.nil?
      solr_props['latest_int'] = [Time.parse(latest).year] unless latest.nil?

      solr_props
    end
  end
end
