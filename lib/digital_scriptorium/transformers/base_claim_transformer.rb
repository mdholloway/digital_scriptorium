# frozen_string_literal: true

module DigitalScriptorium
  # Base transformer class providing a common interface for all transformers.
  class BaseClaimTransformer

    def initialize(prefix, claim)
      @prefix = prefix
      @claim = claim
    end

    def display_values
      []
    end

    def search_values
      []
    end

    def facet_values
      []
    end

    def extra_props
      {}
    end

    def to_solr_props
      solr_props = {}
      solr_props["#{prefix}_display"] = display_values if display_values.any?
      solr_props["#{prefix}_search"] = search_values if search_values.any?
      solr_props["#{prefix}_facet"] = facet_values if facet_values.any?
      solr_props.merge(extra_props)
    end
  end
end
