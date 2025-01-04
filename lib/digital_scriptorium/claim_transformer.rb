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

      if claim.value_type? EntityIdValue
        entity_id = claim.entity_id_value
        referenced_item = export_hash[entity_id]
        value = referenced_item.label('en')
      elsif claim.value_type? TimeValue
        value = claim.time_value
      else
        value = claim.data_value
      end
    
      solr_props["#{prefix}"] = [value] if requested_fields.include? 'id'
      solr_props["#{prefix}_meta"] = [value] if requested_fields.include? 'meta'

      display_props = { 'PV' => value }
    
      if authority_property_id && claim.qualifiers_by_property_id?(authority_property_id)
        authority_id = claim.qualifier_by_property_id(authority_property_id).entity_id_value
        authority = export_hash[authority_id]
    
        if authority
          label = authority.label('en')
          display_props['QL'] = label

          external_uri = authority.claim_by_property_id(EXTERNAL_URI)&.data_value
    
          wikidata_id = authority.claim_by_property_id(WIKIDATA_QID)&.data_value
          wikidata_uri = wikidata_id && "https://www.wikidata.org/wiki/#{wikidata_id}"

          # Only one or the other of these seem to exist for a given item in practice.
          display_props['QU'] = external_uri if external_uri
          display_props['QU'] = wikidata_uri if wikidata_uri
      
          solr_props["#{config['prefix']}_display"] = [display_props.to_json] if config['fields'].include? 'display'
          solr_props["#{config['prefix']}_search"] = [value, label].uniq if config['fields'].include? 'search'
          solr_props["#{config['prefix']}_facet"] = [label] if config['fields'].include? 'facet'
    
          return solr_props
        end
      end
    
      solr_props["#{config['prefix']}_display"] = [display_props.to_json] if config['fields'].include? 'display'
      solr_props["#{config['prefix']}_search"] = [value] if config['fields'].include? 'search'
      solr_props["#{config['prefix']}_facet"] = [value] if config['fields'].include? 'facet'
    
      solr_props["images_facet"] = ['Yes'] if value && claim.property_id == IIIF_MANIFEST
      solr_props["#{config['prefix']}_link"] = [value] if config['fields'].include? 'link'
    
      solr_props
    end
  end
end
