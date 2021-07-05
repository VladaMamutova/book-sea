class RatingSerializer < ActiveModel::Serializer
  attributes :user_uid, :status, :limit, :score

  def status
    object.status.rank
  end

  def limit
    object.status.limit
  end
end
