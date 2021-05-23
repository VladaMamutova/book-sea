# Adding some syntactic sugar - make service objects behave more like a proc.
# Proccall invokes the block, setting the block’s parameters
# to the values in params using something close to method calling semantics.
# It returns the value of the last expression evaluated in the block.
# Use Service.call(params) instead of Service.new(params).call
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
