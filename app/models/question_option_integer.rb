class QuestionOptionInteger < QuestionOption

  def value
    read_attribute(:value).to_i
  end

end