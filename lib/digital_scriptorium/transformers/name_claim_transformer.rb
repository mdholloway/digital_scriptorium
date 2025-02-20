# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for associated name (P14) claims.
  # NOTE: Name claims produce fields prefixes derived from the value of their role (P15) qualifiers
  # (owner, author, scribe, artist, agent).
  class NameClaimTransformer < QualifiedClaimTransformerWithFacetFallback
    include PropertyId

    def initialize(claim, export_hash, **kwargs)
      super(claim, export_hash, prefix: role_prefix(claim, export_hash), authority_id: kwargs[:authority_id])
    end

    def role_prefix(claim, export_hash)
      role_entity_id = claim.qualifiers_by_property_id(ROLE_IN_AUTHORITY_FILE)&.first&.entity_id_value
      raise 'Missing role qualifier for name claim' unless role_entity_id

      role_item = export_hash[role_entity_id]
      role_label = role_item.label('en')
      role_label.split.last.downcase
    end
  end
end
