class PersonProfile < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :name

  belongs_to_and_marks_latest_within :person
end
