class Admin::AddressRequestsController < AdminControllerBase
  def show
    @address_request = AddressRequest.find(params[:id])

    unless @address_request.request_recipient_user.has_mailable_address?
      @recipient_messages = @address_request.get_latest_recipient_messages
      @address_request.mark_facebook_thread_activity_as_latest!
    end
  end
end
