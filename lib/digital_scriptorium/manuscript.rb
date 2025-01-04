# frozen_string_literal: true

module DigitalScriptorium
  # An item representing a Digital Scriptorium manuscript (instance of Q1)
  class Manuscript < DsItem
    include PropertyId

    def ds_id
      claim_by_property_id(DS_ID).data_value # P1
    end

    def holding_id
      claim_by_property_id(MANUSCRIPT_HOLDING).entity_id_value # P2
    end
  end
end
