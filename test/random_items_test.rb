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
      Model.expects(:rand).with(9).returns(1)
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
        Model.expects(:rand).with(9).returns(1)
        Model.expects(:find).with(:first, { :limit => 1, :offset => 1, :include => :other_model })
        Model.random(:first, :include => :other_model)        
      end
    end
  end
  
  context "random(:all)" do
    should "find :limit random items" do
      Model.expects(:random_first).times(3)
      Model.random(:all, :limit => 3)      
    end
    context "with no :limit" do
      should "default to 1" do
        Model.expects(:random_first)
        Model.random(:all)        
      end
    end
    context "with options" do
      should "forward them to random_first" do
        Model.expects(:random_first).times(3).with(:include => :other_model)
        Model.random(:all, :limit => 3, :include => :other_model)
      end
    end
  end
  
end