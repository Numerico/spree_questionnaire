class QuestionOptionInteger < QuestionOption

  def value=(value)
    self[:value] = value.to_str
  end

  def value
    self[:value].to_i
  end

end