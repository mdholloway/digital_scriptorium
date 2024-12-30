# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # An item representing a Digital Scriptorium manuscript (instance of Q1)
  class Manuscript < WikibaseRepresentable::Model::Item
    include PropertyId
    include StatementHelper

    def ds_id
      ds_id_claim = first_claim_by_property_id DS_ID # P1
      return nil unless ds_id_claim

      ds_id_claim.main_snak&.data_value&.value
    end

    def holding_id
      holding_id_claim = first_claim_by_property_id MANUSCRIPT_HOLDING # P2
      return nil unless holding_id_claim

      holding_id_claim.main_snak&.data_value&.value
    end
  end
end
