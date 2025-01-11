# frozen_string_literal: true

module DigitalScriptorium
  # Special-purpose transformer for name (P14) claims
  class NameClaimTransformer
    include PropertyId

    def self.transform(claim, export_hash)
      return {} unless claim.qualifiers_by_property_id? ROLE_IN_AUTHORITY_FILE

      prefix = get_role_prefix(claim, export_hash)
      recorded_name = claim.data_value
      original_script = claim.qualifiers_by_property_id(IN_ORIGINAL_SCRIPT)&.first&.data_value&.value
      linked_terms = get_linked_terms(claim, export_hash)

      build_solr_props(prefix, recorded_name, original_script, linked_terms)
    end

    def self.build_solr_props(prefix, recorded_value, original_script, linked_terms)
      linked_term_labels = get_labels(linked_terms)

      {
        "#{prefix}_display" => [{
          'recorded_value' => recorded_value,
          'original_script' => original_script,
          'linked_terms' => linked_terms.any? ? linked_terms : nil
        }.compact.to_json],
        "#{prefix}_search" => ([recorded_value, original_script].compact + linked_term_labels).uniq,
        "#{prefix}_facet" => linked_term_labels.uniq
      }
    end

    def self.get_linked_terms(claim, export_hash)
      linked_terms = []

      claim.qualifiers_by_property_id(NAME_IN_AUTHORITY_FILE)&.each do |qualifier|
        term = {}
        term['label'] = export_hash[qualifier.entity_id_value].label('en')

        wikidata_id = export_hash[qualifier.entity_id_value].claims_by_property_id(WIKIDATA_QID)&.first&.data_value
        wikidata_url = wikidata_id && "https://www.wikidata.org/wiki/#{wikidata_id}"
        term['source_url'] = wikidata_url if wikidata_url

        linked_terms << term
      end

      linked_terms
    end

    def self.get_role_prefix(claim, export_hash)
      role_entity_id = claim.qualifiers_by_property_id(ROLE_IN_AUTHORITY_FILE).first.entity_id_value
      role_item = export_hash[role_entity_id]
      role_label = role_item.label('en')
      role_label.downcase.split.last
    end

    def self.get_labels(linked_terms)
      linked_terms.map { |term| term['label'] }
    end
  end
end
