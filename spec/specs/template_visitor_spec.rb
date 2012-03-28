require 'spec_helper'

module Expansions
  describe TemplateVisitor do
    let(:all_templates){[]}
    let(:registry){fake}
    let(:file){fake}
    let(:args){{:processor_registry => registry,:file => file}}
    let(:the_processor){fake}
    let(:sut){TemplateVisitor.new(args)}
    before (:each) do
      TemplateProcessors.stub(:instance).and_return(nil)
    end

    context "when processing a template" do
      before (:each) do
        registry.stub(:get_processor_for).and_return(the_processor)
      end

      context "and the generated file already exists" do
        let(:file_name){"some.file"}
        before (:each) do
          the_processor.stub(:remove_template_extension_from).and_return(file_name)
          file.stub(:exists?).with("./some.file").and_return(true)
        end

        before (:each) do
          sut.run_using("some.file.name")
        end
        it "should delete the original file" do
          file.should have_received(:delete,"./#{file_name}") 
        end
      end
      context "and the generated file does not already exists" do
        let(:file_name){"some.file"}
        before (:each) do
          the_processor.stub(:remove_template_extension_from).and_return(file_name)
          file.stub(:exists?).with("./some.file").and_return(false)
        end

        before (:each) do
          sut.run_using(file_name)
        end

        it "should not try to delete the original file" do
          file.should_not have_received(:delete)
        end
      end

      context "that represents a dotfile" do
        let(:file_name){"blah/bashrc.dotfile.erb"}
        let(:options){{}}

        before (:each) do
          registry.stub(:get_processor_for).and_return(the_processor)
          the_processor.stub(:remove_template_extension_from).ignore_arg.and_return("bashrc.dotfile")
        end
        before (:each) do
          sut.run_using(file_name)
        end

        it "should tell the template to be expanded to a file with dotfile naming conventions" do
          the_processor.should have_received(:process,:input => file_name,:output => "blah/.bashrc")
        end
      end
      context "that represents a non dotfile" do
        let(:file_name){"blah/bashrc.erb"}
        let(:options){{}}

        before (:each) do
          registry.stub(:get_processor_for).and_return(the_processor)
          the_processor.stub(:remove_template_extension_from).ignore_arg.and_return("bashrc")
        end
        before (:each) do
          sut.run_using(file_name)
        end

        it "should tell the template to be expanded to a file without the template name" do
          the_processor.should have_received(:process,:input => file_name,:output => "blah/bashrc")
        end
      end
    end
  end
end
