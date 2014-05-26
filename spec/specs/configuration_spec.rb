describe 'Configatron facade' do
  it "can configure configatron using the facade method" do
    configure({
      age: 42
    })

    configuration.age.should == 42
  end
end
