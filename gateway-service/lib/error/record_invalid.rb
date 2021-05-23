module Error
  class RecordInvalid < StandardError
    attr_reader :details

    def initialize(message, details)
      @details = details
      super(message)
    end
  end
end
