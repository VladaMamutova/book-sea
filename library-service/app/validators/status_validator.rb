class StatusValidator < ActiveModel::Validator
  attr_reader :status

  def validate(record)
    @record = record
    puts @status
    @status ||= @record.status
    puts @status

    if @status.blank?
      @record.errors.add(:status, message: "can't be blank")
    elsif not_a_status?
      @record.errors.add(:status, message: "must be one of the following values: 'new', 'used', 'bad_condition', 'lost'")
    end
  end

  def validate_status(record, status)
    @status = status

    validate(record)
    record.errors.empty?
  end

  private

  def not_a_status?
    %w[new used bad_condition lost].exclude? @status.to_s
  end
end
