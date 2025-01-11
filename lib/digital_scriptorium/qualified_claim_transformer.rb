# frozen_string_literal: true

require 'time'
require 'wikibase_representable'

module DigitalScriptorium
  # Transformer for converting qualified claims of Digital Scriptorium items into Solr fields.
  class QualifiedClaimTransformer
    include PropertyId

    def self.transform(claim, export_hash, config)
      recorded_value = primary_value_from_claim(claim, export_hash)
      original_script = claim.qualifiers_by_property_id(IN_ORIGINAL_SCRIPT)&.first&.data_value&.value
      linked_terms = get_linked_terms(claim, export_hash, config)

      build_solr_props(claim, config['prefix'], recorded_value, original_script, linked_terms)
    end

    def self.build_solr_props(claim, prefix, recorded_value, original_script, linked_terms)
      linked_term_labels = get_labels(linked_terms)

      {
        "#{prefix}_display" => [{
          'recorded_value' => recorded_value,
          'original_script' => original_script,
          'linked_terms' => linked_terms
        }.compact.to_json],
        "#{prefix}_search" => ([recorded_value, original_script].compact + linked_term_labels).uniq,
        "#{prefix}_facet" => linked_term_labels.uniq
      }.merge(get_date_props(claim))
    end

    def self.get_date_props(claim)
      return {} unless claim.qualifiers && claim.property_id == PRODUCTION_DATE_AS_RECORDED

      century = time_value_from_qualifier(claim, CENTURY)
      earliest = time_value_from_qualifier(claim, EARLIEST_DATE)
      latest = time_value_from_qualifier(claim, LATEST_DATE)

      {
        'date_meta' => [claim.data_value],
        'century_int' => [parse_year(century)],
        'earliest_int' => [parse_year(earliest)],
        'latest_int' => [parse_year(latest)]
      }
    end

    def self.get_linked_terms(claim, export_hash, config)
      linked_terms = []

      claim.qualifiers_by_property_id(config['authority']).each do |qualifier|
        authority_id = qualifier.entity_id_value
        authority = export_hash[authority_id]
        linked_terms << get_linked_term(authority) if authority
      end

      linked_terms
    end

    def self.get_linked_term(authority)
      term = { 'label' => authority.label('en') }

      external_uri = authority.claims_by_property_id(EXTERNAL_URI)&.first&.data_value
      wikidata_id = authority.claims_by_property_id(WIKIDATA_QID)&.first&.data_value
      wikidata_uri = wikidata_id && "https://www.wikidata.org/wiki/#{wikidata_id}"

      # Only one or the other of these seem to exist for a given item in practice.
      term['source_url'] = (external_uri || wikidata_uri)
      term.compact
    end

    def self.primary_value_from_claim(claim, export_hash)
      if claim.value_type? WikibaseRepresentable::Model::EntityIdValue
        entity_id = claim.entity_id_value
        referenced_item = export_hash[entity_id]
        referenced_item.label('en')
      else
        claim.data_value
      end
    end

    def self.get_labels(linked_terms)
      linked_terms.map { |term| term['label'] }
    end

    def self.time_value_from_qualifier(claim, property_id)
      claim.qualifiers_by_property_id(property_id)&.first&.time_value
    end

    # Wikibase date format "resembling ISO 8601": +YYYY-MM-DDT00:00:00Z
    # https://www.wikidata.org/wiki/Help:Dates#Time_datatype
    def self.parse_year(date)
      Time.iso8601(date[1..]).year
    end
  end
end
