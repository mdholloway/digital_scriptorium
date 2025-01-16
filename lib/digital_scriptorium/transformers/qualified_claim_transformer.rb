# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for converting qualified claims of Digital Scriptorium items into Solr fields.
  class QualifiedClaimTransformer < BaseClaimTransformer
    include PropertyId

    attr_reader :export_hash, :authority_id

    def initialize(claim, export_hash, **kwargs)
      super(claim, **kwargs)
      @export_hash = export_hash
      @authority_id = kwargs[:authority_id]
    end

    def display_values
      [display_value(main_snak_value, in_original_script, linked_terms)]
    end

    def search_values
      [main_snak_value, in_original_script, linked_term_labels].flatten.compact.uniq
    end

    def facet_values
      linked_term_labels
    end

    def in_original_script
      claim.qualifiers_by_property_id(IN_ORIGINAL_SCRIPT)&.first&.data_value&.value
    end

    def external_uri(authority)
      authority.claims_by_property_id(EXTERNAL_URI)&.first&.data_value
    end

    def wikidata_id(authority)
      authority.claims_by_property_id(WIKIDATA_QID)&.first&.data_value
    end

    def wikidata_uri(authority)
      wikidata_id(authority) && "https://www.wikidata.org/wiki/#{wikidata_id(authority)}"
    end

    def linked_term_for(authority)
      {
        'label' => authority.label('en'),
        'source_url' => external_uri(authority) || wikidata_uri(authority)
      }.compact
    end

    def linked_terms
      @linked_terms ||= begin
        linked_terms = []

        claim.qualifiers_by_property_id(authority_id)&.each do |qualifier|
          authority_file_item_id = qualifier.entity_id_value
          authority = export_hash[authority_file_item_id]
          linked_terms << linked_term_for(authority) if authority
        end

        linked_terms.uniq
      end
    end

    def linked_term_labels
      @linked_term_labels ||= linked_terms.map { |term| term['label'] }.uniq
    end

    def main_snak_value
      if claim.value_type? WikibaseRepresentable::Model::EntityIdValue
        entity_id = claim.entity_id_value
        referenced_item = export_hash[entity_id]
        referenced_item.label('en')
      else
        claim.data_value
      end
    end
  end
end
