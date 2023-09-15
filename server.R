function(input, output, session) {
  renderSurvey()
 
  observeEvent(input$submit, {
    
  
  toyboard <- board_connect()
  
  previous <- pin_read(toyboard, name = "renatadiaz/workshop_survey_responses")
  
    
    # Obtain and and append submitted results
    response <- getSurveyData(custom_id = max(previous$subject_id) + 1,
      include_dependencies = FALSE)
    
    timestamp <- data.frame(
      subject_id = response$subject_id[1],
      question_id = "timestamp",
      question_type = "time",
      response = as.character(Sys.time())
    )
    
    response <- bind_rows(response, timestamp)
    
    
    updated <- bind_rows(previous, response)
    
    # Write back to pin
    
    toyboard |>
      pin_write(updated, "renatadiaz/workshop_survey_responses")

    # Show submission message
    showModal(
      modalDialog(
        title = "Thanks for your thoughts!"
      )
    )
  })
  
  
}