class UserProfile < ActiveRecord::Base
  include AppendOnlyModel

  FACEBOOK_FIELDS = %w(id name first_name middle_name last_name location gender email birthday)

  belongs_to_and_marks_latest_within :user

  before_save do
    User.invalidate_birthday_for_user_id(self.user_id)
  end

  def direct_object_pronoun
    gender_pronoun ["him", "her", "them"]
  end

  def possessive_pronoun
    gender_pronoun ["his", "her", "their"]
  end

  def subject_pronoun
    gender_pronoun ["he", "she", "they"]
  end

  def gender_pronoun(pronouns)
    case self.gender
    when "male"
      pronouns[0]
    when "female"
      pronouns[1]
    else
      pronouns[2]
    end
  end
end
