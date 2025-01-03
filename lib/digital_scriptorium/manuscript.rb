# frozen_string_literal: true

module DigitalScriptorium
  # An item representing a Digital Scriptorium manuscript (instance of Q1)
  class Manuscript < DsItem
    include PropertyId
    include WikibaseRepresentable::Model::DataValueHelper

    def ds_id
      data_value_from claim_by_property_id(DS_ID) # P1
    end

    def holding_id
      entity_id_value_from claim_by_property_id(MANUSCRIPT_HOLDING) # P2
    end
  end
end
