class OrderCreationException < Exception
  def initialize(errors)
    @errors = errors
  end

  def message
    "Error creating order: #{@errors.inspect}"
  end
end
