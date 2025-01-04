# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # Represents a Digital Scriptorium item
  class DsItem < WikibaseRepresentable::Model::Item
    def instance_of_claims
      claims_by_property_id PropertyId::INSTANCE_OF # P16
    end

    def has_instance_of_claims?
      !instance_of_claims.nil?
    end

    # TODO: polymorphism
    def ds_id
      claim_by_property_id(PropertyId::DS_ID).data_value # P1
    end

    def holding_id
      claim_by_property_id(PropertyId::MANUSCRIPT_HOLDING).entity_id_value # P2
    end

    def described_manuscript_id
      claim_by_property_id(PropertyId::DESCRIBED_MANUSCRIPT).entity_id_value # P3
    end

    def iiif_manifest
      claim_by_property_id(PropertyId::IIIF_MANIFEST).entity_id_value # P41
    end

    def core_model_item?
      instance_of_claims.any? { |claim| ItemId::CORE_MODEL_ITEMS.include? claim.entity_id_value }
    end

    def manuscript?
      instance_of_claims.any? { |claim| ItemId::MANUSCRIPT == claim.entity_id_value }
    end

    def holding?
      instance_of_claims.any? { |claim| ItemId::HOLDING == claim.entity_id_value }
    end

    def record?
      instance_of_claims.any? { |claim| ItemId::RECORD == claim.entity_id_value }
    end
  end
end
