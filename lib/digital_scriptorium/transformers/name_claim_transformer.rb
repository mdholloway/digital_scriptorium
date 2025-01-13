# frozen_string_literal: true

module DigitalScriptorium
  # Special-purpose transformer for name (P14) claims
  class NameClaimTransformer
    include PropertyId

    def self.transform(claim, export_hash)
      return {} unless claim.qualifiers_by_property_id? ROLE_IN_AUTHORITY_FILE

      prefix = get_role_prefix(claim, export_hash)
      recorded_value = claim.data_value
      original_script = claim.qualifiers_by_property_id(IN_ORIGINAL_SCRIPT)&.first&.data_value&.value
      linked_terms = get_linked_terms(claim, export_hash)

      build_solr_props(prefix, recorded_value, original_script, linked_terms)
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
        "#{prefix}_facet" => linked_term_labels.any? ? linked_term_labels : [recorded_value]
      }
    end

    def self.get_linked_terms(claim, export_hash)
      linked_terms = []

      claim.qualifiers_by_property_id(NAME_IN_AUTHORITY_FILE)&.each do |qualifier|
        authority_id = qualifier.entity_id_value
        authority = export_hash[authority_id]
        linked_terms << get_linked_term(authority) if authority
      end

      linked_terms.uniq
    end

    def self.get_linked_term(authority)
      term = { 'label' => authority.label('en') }
      wikidata_id = authority.claims_by_property_id(WIKIDATA_QID)&.first&.data_value
      wikidata_uri = wikidata_id && "https://www.wikidata.org/wiki/#{wikidata_id}"
      term['source_url'] = wikidata_uri
      term.compact
    end

    def self.get_role_prefix(claim, export_hash)
      role_entity_id = claim.qualifiers_by_property_id(ROLE_IN_AUTHORITY_FILE).first.entity_id_value
      role_item = export_hash[role_entity_id]
      role_label = role_item.label('en')
      role_label.downcase.split.last
    end

    def self.get_labels(linked_terms)
      linked_terms.map { |term| term['label'] }.uniq
    end
  end
end
