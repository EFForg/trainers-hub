module FeedbackHelper
  def survey_prompt(question)
    question.prompt.strip.tap do |prompt|
      prompt << ":" unless prompt =~ /[.?!:]$/
      prompt << "*" if question.required?
    end
  end

  def survey_response_histogram(question)
    table = question.options.order(:position).map do |option|
      [option.value, question.responses.where(value: option.value).count]
    end.to_h

    total = table.values.sum
    table.map do |option, count|
      data = OpenStruct.new(
        count: count,
        percentage: 100.0 * count / total,
        frequent?: table.values.all?{ |v| v <= count }
      )
      [option, data]
    end.to_h
  end

  def quick_feedback_responses
    questions = SurveyQuestion.
      where(survey: Feedback::QUICK_SURVEY).
      order(:position).
      preload(:options)

    questions.map do |question|
      SurveyResponse.new(survey_question: question)
    end
  end

  def cache_key_for_quick_survey
    # SurveyQuestion.where(survey: Feedback::QUICK_SURVEY).cache_key

    # Let's just clear the cache whenever it changes...
    "quick-survey"
  end
end
