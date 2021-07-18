class ReportService
  REPORT_SERVICE_URL = Rails.configuration.report_service_url
  private_constant :REPORT_SERVICE_URL

  def books_genre_report
    response = RestClient.get "#{REPORT_SERVICE_URL}/reports/books-genre", { accept: :json }
    JSON.parse(response.body)
  end

  def books_return_report
    response = RestClient.get "#{REPORT_SERVICE_URL}/reports/books-return", { accept: :json }
    JSON.parse(response.body)
  end
end
