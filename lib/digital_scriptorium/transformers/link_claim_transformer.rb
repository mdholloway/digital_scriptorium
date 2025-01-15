# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for extracting links from relevant Digital Scriptorium claims.
  class LinkClaimTransformer < BaseClaimTransformer
    def extra_props
      { "#{@prefix}_link" => [@claim.data_value] }
    end
  end
end
