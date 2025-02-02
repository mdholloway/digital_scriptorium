# frozen_string_literal: true

module DigitalScriptorium
  # An item representing a Digital Scriptorium manuscript (instance of Q1)
  class Manuscript < DsItem
    include PropertyId

    def ds_id
      claims_by_property_id(DS_ID)&.first&.data_value # P1
    end

    def holding_ids
      claims_by_property_id(MANUSCRIPT_HOLDING)&.map(&:entity_id_value) # P2
    end
  end
end
