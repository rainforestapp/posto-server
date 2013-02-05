class App < ActiveRecord::Base
  include AppendOnlyModel
  attr_accessible :name

  def self.lulcards
    @lulcards ||= App.where(name: "lulcards").first_or_create!
  end
end
