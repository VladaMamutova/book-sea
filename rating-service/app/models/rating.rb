class Rating < ApplicationRecord

  enum status: %i[bronze silver gold platinim]
end
