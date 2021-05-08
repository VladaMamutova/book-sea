module Error
  class RecordInvalid < StandardError
    attr_reader :details # ActiveModel::Errors

    def initialize(errors)
      @details = errors
      super('Record is invalid')
    end
  end
end
