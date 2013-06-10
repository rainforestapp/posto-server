class App < ActiveRecord::Base
  include AppendOnlyModel
  attr_accessible :name

  def self.lulcards
    @lulcards ||= App.where(name: "lulcards", apple_app_id: "585112745", domain: "lulcards.com").first_or_create!
  end

  def self.babygrams
    @babygrams ||= App.where(name: "babygrams", apple_app_id: "634710276", domain: "babygramsapp.com").first_or_create!
  end

  def self.by_name(name)
    raise "Bad app name #{name}" unless name == "lulcards" || name == "babygrams"
    name == "lulcards" ? self.lulcards : self.babygrams
  end
end
