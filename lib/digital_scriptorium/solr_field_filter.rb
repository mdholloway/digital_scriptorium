# frozen_string_literal: true

require 'set'

module DigitalScriptorium
  # Filters Solr documents to remove items not requested in config
  class SolrFieldFilter
    FILTERABLE_FIELDS = Set['display', 'search', 'facet']

    def self.filter(solr_item, property_config)
      solr_item.select do |field, _|
        suffix = field.split('_').last
        !filterable?(suffix) || requested?(suffix, property_config)
      end
    end

    def self.filterable?(suffix)
      FILTERABLE_FIELDS.include? suffix
    end

    def self.requested?(suffix, property_config)
      property_config['fields'].include? suffix
    end
  end
end
