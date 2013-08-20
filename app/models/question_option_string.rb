class QuestionOptionString < QuestionOption

  def value
    read_attribute(:value).to_s
  end

end