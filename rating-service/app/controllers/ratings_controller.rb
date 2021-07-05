class RatingsController < ApplicationController
  before_action :set_rating, except: %i[create]

  # POST /rating/user/:user_uid
  def create
    @rating = Rating.create(user_uid: params[:user_uid], score: 0, status: Status.find_by(rank: 'no_rank'))

    render json: @rating, serializer: RatingSerializer, status: :created
  end

  # GET /rating/user/:user_uid
  def show
    render json: @rating, serializer: RatingSerializer
  end

  # POST /rating/user/:user_uid/update
  def update_score
    new_score = @rating.score
    status = @rating.status
    operation = "none"
    if (params[:in_time] && params[:good_condition])
      new_score += 1
      new_status = increase_status(status, new_score)
      operation = "increased" if new_status != status
    else
      new_score -= 1 if new_score > 0
      new_status = decrease_status(status, new_score)
      operation = "decreased" if new_status != status
    end

    @rating.update!(score: new_score, status: new_status)

    response = {
      status: @rating.status.rank,
      score: @rating.score,
      limit: @rating.status.limit,
      operation: operation
    }
    render json: response
  end

  private

  def set_rating
    @rating = Rating.find_by(user_uid: params[:user_uid]) # nil if not found
    raise ActiveRecord::RecordNotFound, "Rating is not found for user '#{params[:user_uid]}'" unless @rating
  end

  def increase_status(status, new_score)
    rank_curr = Status.ranks[status.rank]
    status_next = Status.find_by(rank: rank_curr + 1)
    if status_next && new_score >= status_next.score
      new_status = status_next
    else
      new_status = status
    end
  end

  def decrease_status(status, new_score)
    return status if new_score >= status.score

    rank_curr = Status.ranks[status.rank]
    status_prev = Status.find_by(rank: rank_curr - 1)
    return status_prev ? status_prev : status
  end
end
