# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  class Meta
    include DataValueHelper

    attr_reader :holding, :manuscript, :record

    def initialize(holding:, manuscript:, record:)
      validate_params(holding, manuscript, record)

      @holding = holding # instance of Q2
      @manuscript = manuscript # instance of Q1
      @record = record # instance of Q3
    end

    def to_solr_document
      doc = SolrDocument.new
      doc.qid_meta = [holding.id, manuscript.id, record.id]
      doc.id = manuscript.ds_id
      # doc.images_facet = record.iiif_manifest

      doc
    end

    def validate_params(holding, manuscript, record)
      return if manuscript.holding_id == holding.id && record.described_manuscript_id == manuscript.id

      raise ArgumentError 'Provided items are not linked as required'
    end
  end
end
