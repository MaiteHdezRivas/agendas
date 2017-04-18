module Searchable
  extend ActiveSupport::Concern

  included do
    include PgSearch

    pg_search_scope :pg_search, {
      against: :ignored, # not used since using a tsvector_column
      using: {
        tsearch: { tsvector_column: 'tsv', dictionary: "spanish", prefix: true }
      },
      ignoring: :accents,
      ranked_by: '(:tsearch)'
    }
  end

end