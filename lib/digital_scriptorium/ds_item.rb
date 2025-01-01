# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # Represents a Digital Scriptorium item
  class DsItem < WikibaseRepresentable::Model::Item
    include DataValueHelper
    include ItemId

    def instance_of_claims
      get_claims_by_property_id INSTANCE_OF # P16
    end

    def core_model_item?
      instance_of_claims.any? { |claim| CORE_MODEL_ITEMS.include? entity_id_value_from claim }
    end

    def manuscript?
      instance_of_claims.any? { |claim| MANUSCRIPT == entity_id_value_from claim }
    end

    def holding?
      instance_of_claims.any? { |claim| HOLDING == entity_id_value_from claim }
    end

    def record?
      instance_of_claims.any? { |claim| RECORD == entity_id_value_from claim }
    end
  end
end
