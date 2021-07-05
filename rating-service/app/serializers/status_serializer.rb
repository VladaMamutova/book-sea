class StatusSerializer < ActiveModel::Serializer
  attributes :rank, :limit, :score
end
