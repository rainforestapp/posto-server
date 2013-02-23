class Admin::AddressRequestsController < AdminControllerBase
  def show
    @address_request = AddressRequest.find(params[:id])

    unless @address_request.request_recipient_user.has_mailable_address?
      @recipient_messages = @address_request.get_latest_recipient_messages
      @address_request.mark_facebook_thread_activity_as_latest!
    end
  end

  def update
    @address_request = AddressRequest.find(params[:id])
    redirected = false

    if params[:address_api_response_id]
      @address_api_response = AddressApiResponse.find(params[:address_api_response_id])
      @address_request.close_with_api_response(@address_api_response)

      if params[:task_token]
        complete_swf_activity_task!
        redirect_to new_admin_address_parse_task_path
        redirected = true
      end
    end

    redirect_to action: :show unless redirected
  end
end
