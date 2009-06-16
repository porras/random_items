require 'test/unit'
require 'rubygems'
require 'active_record'
require 'mocha'
require 'shoulda'
require 'random_items'

class Model < ActiveRecord::Base;end

class RandomItemsTest < Test::Unit::TestCase
  
  context "random(:first)" do
    should "find a random item" do
      Model.expects(:count).returns(10)
      Model.expects(:rand).with(10).returns(1)
      Model.expects(:find).with(:first, { :limit => 1, :offset => 1 })
      Model.random(:first)      
    end
    context "in a table with one item" do
      should "find that item" do
        Model.expects(:count).returns(1)
        Model.expects(:rand).never
        Model.expects(:find).with(:first)
        Model.random(:first)        
      end
    end
    context "in a table with zero items" do
      should "return nil" do
        Model.expects(:count).returns(0)
        Model.expects(:rand).never
        Model.expects(:find).never
        assert_nil Model.random(:first)  
      end
    end
    context "with options" do
      should "forward them to find()" do
        Model.expects(:count).returns(10)
        Model.expects(:rand).with(10).returns(1)
        Model.expects(:find).with(:first, { :limit => 1, :offset => 1, :include => :other_model })
        Model.random(:first, :include => :other_model)        
      end
    end
    context "with conditions" do
      should "forward them to count() and find()" do
        Model.expects(:count).with({:conditions => { :column => "value" }}).returns(10)
        Model.expects(:rand).with(10).returns(1)
        Model.expects(:find).with(:first, { :limit => 1, :offset => 1, :conditions => {:column => "value" } })
        Model.random(:first, :conditions => { :column => "value"})
      end
    end
    context "with count option" do
      should "use the given count value instead of querying" do
        Model.expects(:count).never
        Model.expects(:rand).with(10).returns(1)
        Model.expects(:find).with(:first, { :limit => 1, :offset => 1, :conditions => {:column => "value" } })
        Model.random(:first, :count => 10, :conditions => { :column => "value"})
      end
    end
  end
  
  context "random(:all)" do
    should "find :limit random items" do
      Model.expects(:random_first).times(3)
      Model.expects(:count).once
      Model.random(:all, :limit => 3)      
    end
    context "without elements" do
      should "return an empty array" do
        Model.stubs(:random_first).returns(nil)
        Model.expects(:count).once
        assert_equal [], Model.random(:all, { :limit => 3 })
      end
    end
    context "with no :limit" do
      should "default to 1" do
        Model.expects(:random_first)
        Model.expects(:count).once
        Model.random(:all)        
      end
    end
    context "with options" do
      should "forward them to random_first" do
        Model.expects(:random_first).times(3).with(:include => :other_model, :count => 10)
        Model.expects(:count).returns(10).once
        Model.random(:all, :limit => 3, :include => :other_model)
      end
    end
  end
  
end