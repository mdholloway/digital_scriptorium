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

    def current_holdings(manuscript, export_hash)
      manuscript.holding_ids.filter_map { |id| export_hash[id] if export_hash[id].current? }
    end
  end
end
