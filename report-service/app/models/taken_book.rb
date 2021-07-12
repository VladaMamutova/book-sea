class TakenBook < ApplicationRecord
  enum status: %i[new used bad_condition lost], _prefix: :status
  # add _prefix, because of the new is a keyword of Active Record method
end
