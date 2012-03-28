require 'spec_helper'

module Expansions
  describe TemplateProcessors do
    context "when a template processor is registered" do
      context "and there is not already a processor registered for the template type" do
        let(:first_processor){fake}
        let(:processors){{}}
        let(:sut){TemplateProcessors.new(processors)}
        before (:each) do
          sut.register_processor(:erb,first_processor)
        end
        it "should be added to the list or processors" do
          processors[:erb].should == first_processor
        end
      end
      context "and there is already a processor registered for the template type" do
        let(:first_processor){fake}
        let(:processors){{}}
        let(:sut){TemplateProcessors.new(processors)}
        before (:each) do
          processors[:erb] = first_processor
        end
        before (:each) do
          @exception = catch_exception{sut.register_processor(:erb,fake)}
        end
        it "should raise an error" do
          (/exist/ =~ @exception.message).should be_true
        end

        it "should not change the processor" do
          processors[:erb].should == first_processor
        end
      end
    end
    context "when getting the processor for a template" do
      let(:first_processor){fake}
      let(:processors){{}}
      let(:sut){TemplateProcessors.new(processors)}
      before (:each) do
        processors[:erb] = first_processor
      end
      context "and it exists" do
        before (:each) do
          @result = sut.get_processor_for("blah.erb")
        end
        it "should return the processor to the caller" do
          @result.should == first_processor 
        end
      end

      context "and it does not exists" do
        before (:each) do
          @exception = catch_exception{sut.get_processor_for("blah.txt")}
        end
        it "should raise an error" do
          (/no process/ =~ @exception.message).should be_true
        end
      end
    end
  end
end
