//= require store/spree_frontend

rangeInputSupport = ->
  testrange = document.createElement "input"
  testrange.setAttribute "type", "range"
  return testrange.type == "range"

$ ->
  if !rangeInputSupport()
    # show and enable fallback
    fallback = $ "select[disabled][name='question[question_options_attributes][0][question_option_answers_attributes][0][answer]']"
    fallback.css 'display', 'block'
    fallback.prop 'disabled', false
    # hide and disable range
    $('input[type="range"]').prop 'disabled', true
    $('div.input.range').hide()
