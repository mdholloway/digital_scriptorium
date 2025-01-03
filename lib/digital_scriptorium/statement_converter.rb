# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  class StatementConverter
    include PropertyId
    include WikibaseRepresentable::Model
    include WikibaseRepresentable::Model::DataValueHelper

    def self.convert(statement, export_hash, config)
      solr_props = {}

      prefix = config['prefix']
      requested_fields = config['fields']
      authority_property_id = config['authority']

      if value_from(statement).is_a? EntityIdValue
        entity_id = entity_id_value_from statement
        referenced_item = export_hash[entity_id]
        value = referenced_item.label('en')
      elsif value_from(statement).is_a? TimeValue
        value = time_value_from statement
      else
        value = data_value_from statement
      end
    
      solr_props["#{prefix}"] = [value] if requested_fields.include? 'id'
      solr_props["#{prefix}_meta"] = [value] if requested_fields.include? 'meta'

      display_props = { 'PV' => value }
    
      if authority_property_id && statement.qualifiers_by_property_id? authority_property_id
        authority_id = entity_id_value_from statement.qualifier_by_property_id(authority)
        authority = export_hash[authority_id]
    
        if authority
          label = authority.label('en')
          display_props['QL'] = label

          external_uri = data_value_from authority.claim_by_property_id(EXTERNAL_URI)
    
          wikidata_id = data_value_from authority.claim_by_property_id(WIKIDATA_QID)
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
    
      solr_props["images_facet"] = ['Yes'] if value && statement.property_id == IIIF_MANIFEST
      solr_props["#{config['prefix']}_link"] = [value] if config['fields'].include? 'link'
    
      solr_props
  end
end
