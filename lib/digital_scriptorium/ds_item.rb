# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # Represents a Digital Scriptorium item
  class DsItem < WikibaseRepresentable::Model::Item
    def instance_of_claims
      claims_by_property_id PropertyId::INSTANCE_OF # P16
    end

    def ds_id
      claims_by_property_id(PropertyId::DS_ID)&.first&.data_value # P1
    end

    def holding_ids
      claims_by_property_id(PropertyId::MANUSCRIPT_HOLDING)&.map(&:entity_id_value) # P2
    end

    def described_manuscript_id
      claims_by_property_id(PropertyId::DESCRIBED_MANUSCRIPT)&.first&.entity_id_value # P3
    end

    def holding_status
      claims_by_property_id(PropertyId::HOLDING_STATUS)&.first&.entity_id_value # P6
    end

    def iiif_manifest
      claims_by_property_id(PropertyId::IIIF_MANIFEST)&.first&.entity_id_value # P41
    end

    def core_model_item?
      instance_of_claims.any? { |claim| ItemId::CORE_MODEL_ITEMS.include? claim.entity_id_value }
    end

    def manuscript?
      instance_of_claims.any? { |claim| claim.entity_id_value == ItemId::MANUSCRIPT }
    end

    def holding?
      instance_of_claims.any? { |claim| claim.entity_id_value == ItemId::HOLDING }
    end

    def record?
      instance_of_claims.any? { |claim| claim.entity_id_value == ItemId::RECORD }
    end

    def current_holding?
      holding? && status_claims.any? { |claim| claim.data_value == 'current' }
    end
  end
end
