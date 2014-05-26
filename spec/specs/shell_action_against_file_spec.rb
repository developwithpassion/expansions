require 'spec_helper'

module Expansions
  describe ShellActionAgainstFile do
    context "when processing a file name" do
      let(:file){"blah.rb"}
      let(:shell){fake}
      let(:sut){ShellActionAgainstFile.new("rm")}

      before (:each) do
        Shell.stub(:instance).and_return(shell)
      end

      before (:each) do
        sut.run_using(file)
      end
      it "should run the shell action against the file" do
        shell.should have_received_message(:run,"rm #{file}")
      end
    end
  end
end
