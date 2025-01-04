# frozen_string_literal: true

module DigitalScriptorium
  class NameStatementConverter
    include PropertyId

    def self.convert(statement, export_hash)
      return {} unless statement.qualifiers_by_property_id? ROLE_IN_AUTHORITY_FILE

      role_entity_id = statement.qualifier_by_property_id(ROLE_IN_AUTHORITY_FILE).entity_id_value
      role_item = export_hash[role_entity_id]
      role_label = role_item.label('en')
      prefix = role_label.downcase.split(' ').last

      recorded_name = statement.data_value
      search_names = [recorded_name]

      name_in_original_script = statement.qualifier_by_property_id(IN_ORIGINAL_SCRIPT)&.data_value
      search_names << name_in_original_script unless name_in_original_script.nil?

      unless statement.qualifiers_by_property_id? NAME_IN_AUTHORITY_FILE
        return {
          "#{prefix}_display" => [{ 'PV' => recorded_name }.to_json],
          "#{prefix}_search" => search_names,
          "#{prefix}_facet" => [recorded_name]
        }
      end

      name_entity_id = statement.qualifier_by_property_id(NAME_IN_AUTHORITY_FILE).entity_id_value
      name_item = export_hash[name_entity_id]
      name_label = name_item.label('en')

      wikidata_id = name_item.claim_by_property_id(WIKIDATA_QID).data_value
      wikidata_url = "https://www.wikidata.org/wiki/#{wikidata_id}"

      search_names << name_label
      display_names = {
        'PV' => recorded_name,
        'QL' => name_label
      }
      display_names['QU'] = wikidata_url if wikidata_url
      display_names['AGR'] = name_in_original_script if name_in_original_script

      {
        "#{prefix}_display" => [display_names.to_json],
        "#{prefix}_search" => search_names,
        "#{prefix}_facet" => [name_label]
      }
    end
  end
end
