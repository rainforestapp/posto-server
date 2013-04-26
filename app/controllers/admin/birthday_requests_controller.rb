class Admin::BirthdayRequestsController < AdminControllerBase
  def show
    @birthday_request = BirthdayRequest.find(params[:id])

    unless @birthday_request.request_recipient_user.has_birthday?
      @recipient_messages = @birthday_request.get_latest_recipient_messages

      @extra_selectable_text = ""
      @birthday_request.mark_facebook_thread_activity_as_latest!
    end
  end

  def update
    @birthday_request = BirthdayRequest.find(params[:id])
    redirected = false

    if params[:parsed_from]
      @birthday_request.append_to_metadata!(parsed_from: params[:parsed_from])
    end

    if params[:birthday]
      birthday = nil

      if birthday =~ /\d\d\d\d/
        birthday = Chronic.parse(params[:birthday] + " 00:00:00") rescue nil
      end

      unless birthday
        birthday = Chronic.parse(params[:birthday] + " 1904 00:00:00") rescue nil 
      end

      unless birthday
        birthday = Chronic.parse(params[:birthday] + "/1904 00:00:00")
      end

      @birthday_request.request_recipient_user.birthday_request_responses.create!(
        birthday: birthday,
        sender_user_id: @birthday_request.request_sender_user_id
      )

      if params[:task_token]
        complete_swf_activity_task!
        redirect_to new_admin_birthday_parse_task_path
        redirected = true
      end
    end

    redirect_to action: :show unless redirected
  end
end
