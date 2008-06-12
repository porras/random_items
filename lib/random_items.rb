class ActiveRecord::Base
  
  # More or less the same interface as ActiveRecord::Base.find
  # Some examples:
  #   Model.random(:first)                          # picks a random item
  #   Model.random(:all, :limit => 5)               # picks 5 random items
  #   Model.random(:first, :include => :relation)   # picks a random item using standard
  #                                                 # AR::B.find options, such as :include
  # In that last case, you are expected not to use options which don't make sense, such as :order =;-)
  #
  def self.random(items, options = {})
    if items == :first
      random_first(options)
    elsif items == :all
      random_all(options)
    else
      raise ArgumentError
    end
  end
  
  private
  
  def self.random_all(options = {})
    options[:limit] ||= 1
    limit = options.delete(:limit)
    (1..limit.to_i).to_a.map { random_first(options) }
  end
  
  def self.random_first(options = {})
    case c = self.count
    when 0: nil
    when 1: find(:first)
    else    find(:first, options.merge(:limit => 1, :offset => rand(c - 1)))
    end
  end
  
end