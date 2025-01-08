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

      solr_props['id'] = [value] if requested_fields.include? 'id'
      solr_props["#{prefix}_meta"] = [value] if requested_fields.include? 'meta'

      unless authority_property_id && claim.qualifiers_by_property_id?(authority_property_id)
        solr_props["#{prefix}_display"] = [{ 'PV' => value }.to_json] if requested_fields.include? 'display'
        solr_props["#{prefix}_search"] = [value] if requested_fields.include? 'search'
        solr_props["#{prefix}_facet"] = [value] if requested_fields.include? 'facet'

        solr_props['images_facet'] = ['Yes'] if value && claim.property_id == IIIF_MANIFEST
        solr_props["#{prefix}_link"] = [value] if requested_fields.include? 'link'

        return solr_props
      end

      display_entries = []
      search_entries = [value]
      facets = []

      claim.qualifiers_by_property_id(authority_property_id).each do |qualifier|
        display_props = { 'PV' => value }

        authority_id = qualifier.entity_id_value
        authority = export_hash[authority_id]

        if authority
          label = authority.label('en')

          display_props['QL'] = label
          search_entries << label
          facets << label

          external_uri = authority.claim_by_property_id(EXTERNAL_URI)&.data_value
          wikidata_id = authority.claim_by_property_id(WIKIDATA_QID)&.data_value
          wikidata_uri = wikidata_id && "https://www.wikidata.org/wiki/#{wikidata_id}"

          # Only one or the other of these seem to exist for a given item in practice.
          display_props['QU'] = external_uri if external_uri
          display_props['QU'] = wikidata_uri if wikidata_uri
        end

        display_entries << display_props.to_json
      end

      solr_props["#{prefix}_display"] = display_entries.uniq if requested_fields.include? 'display'
      solr_props["#{prefix}_search"] = search_entries.uniq if requested_fields.include? 'search'
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
