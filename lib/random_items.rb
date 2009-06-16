class ActiveRecord::Base
  
  # The interface is almost the same as that of <tt>ActiveRecord::Base.find</tt>.
  # 
  # Some examples:
  # 
  # Picking a random item:
  # 
  #   Model.random(:first)
  # 
  # Picking 5 random items:
  # 
  #   Model.random(:all, :limit => 5)
  # 
  # Pickings a random item using standard <tt>ActiveRecord::Base.find</tt> options, such as <tt>:include</tt>
  # 
  #   Model.random(:first, :include => :relation)
  # 
  # In that last case, you are expected not to use options which don't make sense, such as <tt>:order</tt> =;-)
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
    case c = self.count(:conditions => options[:conditions])
    when 0: nil
    when 1: find(:first)
    else    find(:first, options.merge(:limit => 1, :offset => rand(c)))
    end
  end
  
end