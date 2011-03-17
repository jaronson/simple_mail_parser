module Email
class HeaderTuple
  attr_accessor :value, :opts
  def initialize(opts={})
    @value = opts[:value] || nil
    @opts  = opts[:opts] || {}
  end

  def to_json(*args)
    { :value => self.value, :opts => self.opts }.to_json
  end
end
end
