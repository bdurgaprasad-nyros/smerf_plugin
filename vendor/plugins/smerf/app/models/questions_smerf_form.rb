# This model class manages the smerf_forms_users DB table. It stores a a record
# for each form a user completes.
# 

class QuestionsSmerfForm < ActiveRecord::Base
  has_many :smerf_responses,
           :dependent => :destroy
  validates_presence_of :responses
  validates_presence_of :question_id
  validates_presence_of :smerf_form_id
  belongs_to :question
  belongs_to :smerf_form
  
  # We save the form responses to the DB in yaml format
  serialize :responses  
  
  # This method finds the form record for the specified user and form
  #
  def QuestionsSmerfForm.find_user_smerf_form(question_id, smerf_form_id)
    # Find the form record for the current user
    questions_smerf_form = nil
    if (question_id > 0)
      questions_smerf_form = QuestionsSmerfForm.find(:first, 
        :conditions => ['smerf_form_id = ? AND question_id = ?', 
        smerf_form_id, question_id])
    else
      raise(RuntimeError, 
        "For the form responses to be saved for a user, a record ID for 
        the user table needs to be specified. This can be set by using 
        setter function self.smerf_user_id, e.g. self.smerf_user_id = 1")
    end 
    
    return questions_smerf_form
  end

  # Create a record for the user for the current form
  #
  def QuestionsSmerfForm.create_records(smerf_form_id, question_id, responses)
    transaction do
      # Create the record for the user
      questions_smerf_form = QuestionsSmerfForm.create(
            :question_id => question_id,
            :smerf_form_id => smerf_form_id,
            :responses => responses)
      # Create response records for all user responses
      responses.each do |question_response|
        # Check if response is a hash, if so process each response 
        # individually, i.e. each response to a question will have it's
        # own response record
        if (question_response[1].kind_of?(Hash) or 
          question_response[1].kind_of?(Array))
          question_response[1].each do |multichoice_response|
            # Bug fix 0.0.4 (thanks Alan Masterson) 
            response = multichoice_response.kind_of?(Array) ? multichoice_response[1] : multichoice_response
            questions_smerf_form.smerf_responses << SmerfResponse.new(
              :question_code => question_response[0],
              :response => response) if (!response.blank?())           
          end
        else          
          questions_smerf_form.smerf_responses << SmerfResponse.new(
            :question_code => question_response[0],
            :response => question_response[1]) if (!question_response[1].blank?()) 
        end
      end
    end
  end

  # Update a record for the user for the current form
  #
  def QuestionsSmerfForm.update_records(smerf_form_id, question_id, responses)
    transaction do
      # Retrieve the response record for the current user
      questions_smerf_form = QuestionsSmerfForm.find_user_smerf_form(
        question_id, smerf_form_id)
      if (questions_smerf_form)
        # Update the record with the new responses 
        questions_smerf_form.update_attribute(:responses, responses)
        # Update response records, we use the activerecord replace method
        # First we find all the existing responses records for this form
        current_responses = SmerfResponse.find(:all, 
          :conditions => ["questions_smerf_form_id = ?", questions_smerf_form.id])  
        # Process responses, if the response has not changed or it's a new 
        # response add it to the array which we will pass to the replace method.
        # This method will add the new one's, and delete one's that are not in
        # the array
        new_responses = Array.new()
        responses.each do |question_response|
          # Check if response is a hash, if so process each response 
          # individually, i.e. each response to a question will have it's
          # own response record
          if (question_response[1].kind_of?(Hash) or 
            question_response[1].kind_of?(Array))
            question_response[1].each do |multichoice_response|
              if (!multichoice_response[1].blank?())
                # Check if this response already exists, if so we add the 
                # SurveyResponse object to the array, otherwise we create a 
                # new response object
                #
                if (found = self.response_exist?(current_responses, 
                  question_response[0], multichoice_response[1]))
                  new_responses << found
                else  
                  new_responses << (SmerfResponse.new(
                    :questions_smerf_form_id => questions_smerf_form.id, 
                    :question_code => question_response[0],
                    :response => multichoice_response[1]))           
                end
              end
            end
          else       
              if (!question_response[1].blank?()) 
                # Check if this response already exists, if so we add the 
                # SurveyResponse object to the array, otherwise we create a 
                # new response object
                #
                if (found = self.response_exist?(current_responses, 
                  question_response[0], question_response[1]))
                  new_responses << found
                else  
                  new_responses << (SmerfResponse.new(
                    :questions_smerf_form_id => questions_smerf_form.id, 
                    :question_code => question_response[0],
                    :response => question_response[1]))
                end
              end
          end
        end
        # Pass the array that holds existing(unchanged) responses as well
        # as new responses to the replace method which will generate deletes
        # and inserts as required
        questions_smerf_form.smerf_responses.replace(new_responses)
      end
    end
  end
  
  private
  
    # This method checks the responses from the form against those currently 
    # stored in the DB for this form and question. If it exists it will return 
    # the SmerfResponse object retrieved from the DB, otherwise it will return nil
    #
    def QuestionsSmerfForm.response_exist?(current_responses, question_code, response)
      response_object = nil
      begin
        current_responses.each do |current_response|
          if (current_response.question_code == question_code and
            current_response.response == response)
            response_object = current_response            
            raise
          end
        end
      rescue
        
      end
      
      return response_object
    end
  
end
