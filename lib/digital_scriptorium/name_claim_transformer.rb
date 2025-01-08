# frozen_string_literal: true

module DigitalScriptorium
  # Special-purpose transformer for name (P14) claims
  class NameClaimTransformer
    include PropertyId

    def self.transform(claim, export_hash)
      return {} unless claim.qualifiers_by_property_id? ROLE_IN_AUTHORITY_FILE

      role_entity_id = claim.qualifiers_by_property_id(ROLE_IN_AUTHORITY_FILE).first.entity_id_value
      role_item = export_hash[role_entity_id]
      role_label = role_item.label('en')
      prefix = role_label.downcase.split.last

      recorded_name = claim.data_value
      display_data = { 'recorded_value' => recorded_name }
      search_terms = [recorded_name]

      name_in_original_script = claim.qualifiers_by_property_id(IN_ORIGINAL_SCRIPT)&.first&.data_value&.value
      display_data['original_script'] = name_in_original_script if name_in_original_script
      search_terms << name_in_original_script if name_in_original_script

      unless claim.qualifiers_by_property_id? NAME_IN_AUTHORITY_FILE
        return {
          "#{prefix}_display" => [display_data.to_json],
          "#{prefix}_search" => search_terms,
          "#{prefix}_facet" => [recorded_name]
        }
      end

      facets = []
      linked_terms = []

      claim.qualifiers_by_property_id(NAME_IN_AUTHORITY_FILE).each do |qualifier|
        term = {}

        name_entity_id = qualifier.entity_id_value
        name_item = export_hash[name_entity_id]
        name_label = name_item.label('en')

        term['label'] = name_label
        search_terms << name_label
        facets << name_label

        wikidata_id = name_item.claims_by_property_id(WIKIDATA_QID)&.first&.data_value
        wikidata_url = wikidata_id && "https://www.wikidata.org/wiki/#{wikidata_id}"
        term['source_url'] = wikidata_url if wikidata_url

        linked_terms << term
      end

      display_data['linked_terms'] = linked_terms.uniq if linked_terms.any?

      {
        "#{prefix}_display" => [display_data.to_json],
        "#{prefix}_search" => search_terms.uniq,
        "#{prefix}_facet" => facets.uniq
      }
    end
  end
end
