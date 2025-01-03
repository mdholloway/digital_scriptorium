# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # Represents a Digital Scriptorium item
  class DsItem < WikibaseRepresentable::Model::Item
    include WikibaseRepresentable::Model::DataValueHelper

    def instance_of_claims
      claims_by_property_id PropertyId::INSTANCE_OF # P16
    end

    def has_instance_of_claims?
      !instance_of_claims.nil?
    end

    # TODO: polymorphism
    def ds_id
      data_value_from claim_by_property_id(PropertyId::DS_ID) # P1
    end

    def holding_id
      entity_id_value_from claim_by_property_id(PropertyId::MANUSCRIPT_HOLDING) # P2
    end

    def described_manuscript_id
      entity_id_value_from claim_by_property_id(PropertyId::DESCRIBED_MANUSCRIPT) # P3
    end

    def iiif_manifest
      data_value_from claim_by_property_id(PropertyId::IIIF_MANIFEST) # P41
    end

    def core_model_item?
      instance_of_claims.any? { |claim| ItemId::CORE_MODEL_ITEMS.include? entity_id_value_from(claim) }
    end

    def manuscript?
      instance_of_claims.any? { |claim| ItemId::MANUSCRIPT == entity_id_value_from(claim) }
    end

    def holding?
      instance_of_claims.any? { |claim| ItemId::HOLDING == entity_id_value_from(claim) }
    end

    def record?
      instance_of_claims.any? { |claim| ItemId::RECORD == entity_id_value_from(claim) }
    end
  end
end
