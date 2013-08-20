FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_questionnaire/factories'
  factory :questionnaire do
    
  end

  factory :question do
    text "is this a test question?" # TODO ffaker
    sequence :position
  end

end
