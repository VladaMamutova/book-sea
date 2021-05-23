class BookFilter < ApplicationService
  START_PAGE = 0
  BOOKS_PER_PAGE = 20

  attr_reader :filter_params, :page, :per_page

  def initialize(params)
    @filter_params = {}
    @filter_params['books.name'] = "%#{params[:name].downcase}%" if params[:name]
    # поиск по началу фамилии автора
    @filter_params['authors.last_name'] = "#{params[:author]}%" if params[:author]
    @filter_params['genres.name'] = params[:genre] if params[:genre]

    @page = [params[:page].to_i - 1, START_PAGE].max
    @per_page = params[:per_page] ? params[:per_page].to_i : BOOKS_PER_PAGE

    super()
  end

  def call
    conditions = generate_array_conditions
    if conditions
      Book.joins(:author, :genre).where(conditions).limit(@per_page).offset(@page * @per_page)
    else
      Book.limit(@per_page).offset(@page * @per_page)
    end
  end

  private

  def generate_array_conditions
    condition_string = ''
    array_conditions = []

    @filter_params.each do |key, value|
      condition_string += ' AND ' unless condition_string.empty?

      # Use placeholder (?) to avoid "SQL injection" attacks.
      condition_string += "LOWER(#{key}) LIKE ?"
      array_conditions << value.downcase
    end

    array_conditions.empty? ? nil : array_conditions.unshift(condition_string)
  end
end
