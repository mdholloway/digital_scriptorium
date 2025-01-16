# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for extracting links from relevant Digital Scriptorium claims.
  class LinkClaimTransformer < BaseClaimTransformer
    def solr_props
      super.merge({ "#{prefix}_link" => [claim.data_value] })
    end
  end
end
