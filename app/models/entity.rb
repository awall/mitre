class Entity < ApplicationRecord
  belongs_to :sentence

  validates :text, :typ, presence: true
end
