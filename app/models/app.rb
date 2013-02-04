class App < ActiveRecord::Base
  include AppendOnlyModel
  attr_accessible :name
end
