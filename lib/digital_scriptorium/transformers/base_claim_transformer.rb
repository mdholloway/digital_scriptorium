# frozen_string_literal: true

module DigitalScriptorium
  # Base transformer class providing a common interface for all transformers.
  class BaseClaimTransformer
    def initialize(claim, **kwargs)
      @claim = claim
      @prefix = kwargs[:prefix]
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

    def display_value(recorded_value, in_original_script = nil, linked_terms = [])
      value = { 'recorded_value' => recorded_value }
      value['original_script'] = in_original_script if in_original_script
      value['linked_terms'] = linked_terms if linked_terms.any?
      value.to_json
    end

    def solr_props
      solr_props = {}
      solr_props["#{@prefix}_display"] = display_values if display_values.any?
      solr_props["#{@prefix}_search"] = search_values if search_values.any?
      solr_props["#{@prefix}_facet"] = facet_values if facet_values.any?
      solr_props.merge(extra_props)
    end
  end
end
