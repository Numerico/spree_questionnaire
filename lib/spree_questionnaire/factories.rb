FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_questionnaire/factories'

  factory :questionnaire do
    factory :questionnaire_with_questions do
      questions { create_list :question, 5 }
    end
  end

  factory :question do
    text "is this a test question?" # TODO ffaker
    sequence :position
    factory :question_with_options do
      questionnaire
      question_options { create_list :question_option_integer, 1 }
    end
  end

  factory :question_option do
  end

  factory :question_option_integer do
    value "1"
  end

  factory :question_option_string do
    value "A"
  end

  factory :question_option_list do
    value ["1", "2", "3"]
  end

end
