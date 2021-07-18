class Status < ApplicationRecord
  validates :rank, presence: true  
  validates :limit, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }  

  enum rank: %i[no_rank bronze silver gold platinum]
end
