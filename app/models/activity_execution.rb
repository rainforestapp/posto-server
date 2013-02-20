class ActivityExecution < ActiveRecord::Base
  include AppendOnlyModel
  attr_accessible :worker, :method, :arguments

  serialize :arguments, Hash
end
