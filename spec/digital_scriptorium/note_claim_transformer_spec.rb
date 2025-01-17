# frozen_string_literal: true

module DigitalScriptorium
  include PropertyId

  RSpec.describe NoteClaimTransformer do
    context 'with a note (P32) claim' do
      json = read_fixture('claims/P32_note.json')
      prefix = Transformers.prefix(NOTE)
      expected = {
        'note_display' => ['{"recorded_value":"Ms. codex."}'],
        'note_search' => ['Ms. codex.']
      }

      it 'provides the note in the display and search fields' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
