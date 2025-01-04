# frozen_string_literal: true

module DigitalScriptorium
  # Represents a meta record consisting of a manuscript, its holding information, and metadata record.
  class DsMeta
    attr_reader :holding, :manuscript, :record

    def initialize(record, export_hash)
      manuscript = export_hash[record.described_manuscript_id]
      holding = export_hash[manuscript.holding_id]

      @holding = holding
      @manuscript = manuscript
      @record = record
    end
  end
end
