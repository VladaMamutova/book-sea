class NameValidator < ActiveModel::Validator
  def validate(record)
    @record = record

    if check_not_empty(@record.first_name, :first_name)
      check_length(@record.first_name, 2, :first_name)
      check_capital_letter(@record.first_name, :first_name)
    end

    if check_not_empty(@record.last_name, :last_name)
      check_length(@record.last_name, 3, :last_name)
      check_capital_letter(@record.last_name, :last_name)
    end

    unless @record.middle_name.blank?
      check_length(@record.middle_name, 3, :middle_name)
      check_capital_letter(@record.middle_name, :middle_name)
    end
  end

  private

  def check_not_empty(field, field_sym)
    return true unless field.blank?

    @record.errors.add(field_sym, message: "can't be blank")
    false
  end

  def check_length(field, length, field_sym)
    return if field.length >= length

    @record.errors.add(field_sym, message: "must consist of at least #{length} symbols")
  end

  def check_capital_letter(field, field_sym)
    return if /[[:upper:]]/.match(field[0]) # or field[0].upcase == field[0]

    @record.errors.add(field_sym, message: 'must begin with capital letter')
  end
end
