class CachedWord < ApplicationRecord
  validates :word, presence: true, uniqueness: true
  validates :score, presence: true
end
