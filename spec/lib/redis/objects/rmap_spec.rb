require_relative '../../../spec_helper'

describe Redis::Objects::RMap do
  describe "Module" do
    it "includes" do
      class Model < ActiveRecord::Base
        include Redis::Objects::RMap
      end
    end

    it "requires title" do
      expect {
        class Foo < ActiveRecord::Base
          include Redis::Objects::RMap
          has_rmap
        end
      }.to raise_error
    end
  end

  describe "Declaration" do
    it "can be simple" do
      class Foo < ActiveRecord::Base
        include Redis::Objects::RMap
        has_rmap 'foo'
      end

      Foo.rmap_options.should == {
        "id_field" => :id,
        "id_proc" => nil,
        "title_field" => :foo,
        "title_proc" => nil
      }
    end

    it "can contain id" do
      class Foo < ActiveRecord::Base
        include Redis::Objects::RMap
        has_rmap 'foo', :bar
      end

      Foo.rmap_options.should == {
        "id_field" => :bar,
        "id_proc" => nil,
        "title_field" => :foo,
        "title_proc" => nil
      }
    end

    it "can contain lambdas" do
      class Foo < ActiveRecord::Base
        include Redis::Objects::RMap
        has_rmap 'foo' => lambda{|x| x.to_s}
      end

      Foo.rmap_options[:title_proc].call(:test).should == 'test'
    end
  end

  describe "Cache" do
    it "works" do
      class Foo < ActiveRecord::Base
        include Redis::Objects::RMap
        has_rmap 'name', :id => lambda{|x| x.to_s}
      end

      Foo.rmap_clear
      Foo.rmap.should == {}

      Foo.create! :name => "test1"
      Foo.should_receive(:rmap_cache)
      Foo.rmap
      Foo.rspec_reset

      Foo.rmap.should == {"1" => "test1"}
      Foo.should_not_receive(:rmap_cache)
      Foo.rmap
      Foo.rspec_reset

      Foo.destroy_all
      Foo.rmap.should == {}
    end
  end
end