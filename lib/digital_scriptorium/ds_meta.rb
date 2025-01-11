# frozen_string_literal: true

module DigitalScriptorium
  # Represents a meta record consisting of a manuscript, its holding information, and metadata record.
  class DsMeta
    include ItemId
    include PropertyId

    attr_reader :holding, :manuscript, :record

    def initialize(record, export_hash)
      manuscript = export_hash[record.described_manuscript_id]
      current_holdings = current_holdings(manuscript, export_hash)

      if current_holdings.size != 1
        raise "Manuscripts must have exactly 1 current holding, found #{current_holdings.size}"
      end

      @holding = current_holdings.first
      @manuscript = manuscript
      @record = record
    end

    def current?(holding)
      holding.claims_by_property_id(HOLDING_STATUS)&.first&.entity_id_value == HOLDING_STATUS_CURRENT
    end

    def current_holdings(manuscript, export_hash)
      manuscript.holding_ids
                .map { |id| export_hash[id] }
                .filter { |holding| current?(holding) }
    end
  end
end
