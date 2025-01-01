# frozen_string_literal: true

module DigitalScriptorium
  # An item representing a Digital Scriptorium manuscript (instance of Q1)
  class Manuscript < DsItem
    include DataValueHelper
    include PropertyId
    include StatementHelper

    def ds_id
      ds_id_claim = first_claim_by_property_id DS_ID # P1

      data_value_from ds_id_claim
    end

    def holding_id
      holding_id_claim = first_claim_by_property_id MANUSCRIPT_HOLDING # P2

      entity_id_value_from holding_id_claim
    end
  end
end
