class PersonProfile < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :name

  belongs_to_and_marks_latest_within :person

  def first_name
    name.split(/\s+/)[0]
  end
end
