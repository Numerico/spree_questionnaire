class QuestionOptionHash < QuestionOption

  def value=(value)
    super(JSON.dump(value))
  end

  def value
    JSON.load(super())
  end

end