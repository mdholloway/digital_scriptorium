# frozen_string_literal: true

module DigitalScriptorium
  # Special-purpose transformer for name (P14) claims
  class NameClaimTransformer
    include PropertyId

    def self.transform(claim, export_hash)
      return {} unless claim.qualifiers_by_property_id? ROLE_IN_AUTHORITY_FILE

      role_entity_id = claim.qualifier_by_property_id(ROLE_IN_AUTHORITY_FILE).entity_id_value
      role_item = export_hash[role_entity_id]
      role_label = role_item.label('en')
      prefix = role_label.downcase.split.last

      recorded_name = claim.data_value
      display_names = { 'PV' => recorded_name }
      search_names = [recorded_name]

      name_in_original_script = claim.qualifier_by_property_id(IN_ORIGINAL_SCRIPT)&.data_value&.value
      display_names['AGR'] = name_in_original_script if name_in_original_script
      search_names << name_in_original_script if name_in_original_script

      unless claim.qualifiers_by_property_id? NAME_IN_AUTHORITY_FILE
        return {
          "#{prefix}_display" => [display_names.to_json],
          "#{prefix}_search" => search_names,
          "#{prefix}_facet" => [recorded_name]
        }
      end

      name_entity_id = claim.qualifier_by_property_id(NAME_IN_AUTHORITY_FILE).entity_id_value
      name_item = export_hash[name_entity_id]
      name_label = name_item.label('en')

      wikidata_id = name_item.claim_by_property_id(WIKIDATA_QID).data_value
      wikidata_url = "https://www.wikidata.org/wiki/#{wikidata_id}"

      search_names << name_label
      display_names['QL'] = name_label
      display_names['QU'] = wikidata_url if wikidata_url

      {
        "#{prefix}_display" => [display_names.to_json],
        "#{prefix}_search" => search_names,
        "#{prefix}_facet" => [name_label]
      }
    end
  end
end
