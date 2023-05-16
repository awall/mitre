class Sentence < ApplicationRecord
  has_many :entities, dependent: :destroy

  validates :text, presence: true
end
