result_data  = "config/spree_questionnaire_result.yml"
if File.exist? result_data
  RESULT_DATA = YAML.load_file result_data
  QuestionnaireResult.load_data RESULT_DATA["attributes"], RESULT_DATA["training"]
end