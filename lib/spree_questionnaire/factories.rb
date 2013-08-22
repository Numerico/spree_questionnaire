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
    factory :question_with_option do
      questionnaire
      question_options { create_list :question_option, 1 }
      factory :question_with_int do
        question_options { create_list :question_option_integer, 1 }
      end
      factory :question_with_array do
        question_options { create_list :question_option_array, 1 }
      end
      factory :question_with_hash do
        question_options { create_list :question_option_hash, 1 }
      end
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

  factory :question_option_array do
    value ["1", "2", "3"]
  end

  factory :question_option_hash do
    value { {
      # key => value
      "1" => "one",
      "2" => "two",
      "3" => "three"
    } }
  end

end
