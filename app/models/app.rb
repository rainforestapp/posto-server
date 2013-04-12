class App < ActiveRecord::Base
  include AppendOnlyModel
  attr_accessible :name

  def self.lulcards
    @lulcards ||= App.where(name: "lulcards", apple_app_id: "585112745", domain: "lulcards.com").first_or_create!
  end

  def self.babycards
    @babycards ||= App.where(name: "babycards", apple_app_id: "634710276", domain: "sendbabycards.com").first_or_create!
  end

  def self.by_name(name)
    raise "Bad app name" unless name == "lulcards" || name == "babycards"
    name == "lulcards" ? self.lulcards : self.babycards
  end
end
