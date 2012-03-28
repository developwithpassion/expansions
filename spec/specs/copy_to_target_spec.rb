require 'spec_helper'

module Expansions
  describe CopyToTarget do
    context "when performing a copy" do
      let(:target){"the_target"}
      let(:shell){fake}
      let(:source){"the_source"}

      before (:each) do
        Shell.stub(:instance).and_return(shell)
        @sut = CopyToTarget.new(target)
      end
      before (:each) do
        @sut.run_using(source)
      end
      it "should copy the source to the target" do
        shell.should have_received(:run,"cp -rf #{source} #{target}")
      end
    end
  end
end
