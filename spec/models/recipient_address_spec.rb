require 'spec_helper'

describe RecipientAddress do
  it "should expire after certain amount of time" do
    create(:expired_recipient_address).should be_expired
  end

  it "should note user has mailable address if recipient address exists and isn't expired" do
    create(:recipient_address).recipient_user.should be_mailable
  end
end
