FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_questionnaire/factories'

  factory :questionnaire do
    user
    introduction { Faker::Lorem.paragraph }
    factory :questionnaire_model do
      is_model true
      user nil
    end
    factory :questionnaire_html do
      introduction "<h1>title1</h1><h2>title2</h2>"
    end
    factory :questionnaire_with_questions do
      questions { create_list :question, 5 }
    end
  end

  factory :question do
    text { Faker::Lorem.paragraph }
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
      factory :questions_with_option do
        question_options { create_list :question_option, 2 }
      end
      factory :questions_with_hash do
        question_options { create_list :question_option_hash, 2 }
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
