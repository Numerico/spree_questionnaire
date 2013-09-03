RESULT_DATA = YAML.load_file "#{RAILS_ROOT}/config/spree_questionnaire_result.yml"

QuestionnaireResult.load_data RESULT_DATA["attributes"], RESULT_DATA["training"]