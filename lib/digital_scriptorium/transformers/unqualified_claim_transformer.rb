# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # Transformer for converting unqualified claims of Digital Scriptorium items into Solr fields.
  class UnqualifiedClaimTransformer
    include PropertyId

    def self.transform(claim, export_hash, config)
      recorded_value = primary_value_from_claim(claim, export_hash)
      original_script = claim.qualifiers_by_property_id(IN_ORIGINAL_SCRIPT)&.first&.data_value&.value

      {
        "#{config['prefix']}_display" => [{
          'recorded_value' => recorded_value,
          'original_script' => original_script
        }.compact.to_json],
        "#{config['prefix']}_search" => [recorded_value, original_script].compact
      }
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
  end
end
