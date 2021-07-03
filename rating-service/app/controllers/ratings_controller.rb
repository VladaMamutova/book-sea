class RatingsController < ApplicationController
  before_action :set_rating, except: %i[create]

  def create
    @rating = Rating.new(user_uid: params[:user_uid], status: 'bronze')
    @rating.save!

    render json: @rating, serializer: RatingSerializer, status: :created
  end

  def show
    render json: @rating, serializer: RatingSerializer
  end

  private

  def set_rating
    @rating = Rating.find_by(user_uid: params[:user_uid]) # nil if not found
    raise ActiveRecord::RecordNotFound, "Rating is not found for user '#{params[:user_uid]}'" unless @rating
  end
end
