# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # Transformer for converting claims of Digital Scriptorium items into Solr fields.
  class ClaimTransformer
    include PropertyId
    include WikibaseRepresentable::Model

    def self.transform(claim, export_hash, config)
      solr_props = {}

      prefix = config['prefix']
      requested_fields = config['fields']
      authority_property_id = config['authority']

      value = primary_value_from_claim(claim, export_hash)
      display_data = { 'recorded_value' => value }
      search_terms = [value]

      solr_props['id'] = [value] if requested_fields.include? 'id'
      solr_props["#{prefix}_meta"] = [value] if requested_fields.include? 'meta'

      value_in_original_script = claim.qualifiers_by_property_id(IN_ORIGINAL_SCRIPT)&.first&.data_value&.value
      display_data['original_script'] = value_in_original_script if value_in_original_script
      search_terms << value_in_original_script if value_in_original_script

      unless authority_property_id && claim.qualifiers_by_property_id?(authority_property_id)
        solr_props["#{prefix}_display"] = [display_data.to_json] if requested_fields.include? 'display'
        solr_props["#{prefix}_search"] = search_terms if requested_fields.include? 'search'
        solr_props["#{prefix}_facet"] = [value] if requested_fields.include? 'facet'

        solr_props['images_facet'] = ['Yes'] if value && claim.property_id == IIIF_MANIFEST
        solr_props["#{prefix}_link"] = [value] if requested_fields.include? 'link'

        return solr_props
      end

      facets = []
      linked_terms = []

      claim.qualifiers_by_property_id(authority_property_id).each do |qualifier|
        authority_id = qualifier.entity_id_value
        authority = export_hash[authority_id]

        next unless authority

        term = {}
        label = authority.label('en')

        term['label'] = label
        search_terms << label
        facets << label

        external_uri = authority.claims_by_property_id(EXTERNAL_URI)&.first&.data_value
        wikidata_id = authority.claims_by_property_id(WIKIDATA_QID)&.first&.data_value
        wikidata_uri = wikidata_id && "https://www.wikidata.org/wiki/#{wikidata_id}"

        # Only one or the other of these seem to exist for a given item in practice.
        term['source_url'] = external_uri if external_uri
        term['source_url'] = wikidata_uri if wikidata_uri

        linked_terms << term
      end

      display_data['linked_terms'] = linked_terms.uniq if linked_terms.any?

      solr_props["#{prefix}_display"] = [display_data.to_json] if requested_fields.include? 'display'
      solr_props["#{prefix}_search"] = search_terms.uniq if requested_fields.include? 'search'
      solr_props["#{prefix}_facet"] = facets.uniq if requested_fields.include? 'facet'

      solr_props
    end

    def self.primary_value_from_claim(claim, export_hash)
      if claim.value_type? EntityIdValue
        entity_id = claim.entity_id_value
        referenced_item = export_hash[entity_id]
        referenced_item.label('en')
      elsif claim.value_type? TimeValue
        claim.time_value
      else
        claim.data_value
      end
    end
  end
end
