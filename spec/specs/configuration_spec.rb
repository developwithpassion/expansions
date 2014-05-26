describe 'Configatron facade' do
  it "can configure configatron using the facade method" do
    configure({
      age: 42
    })

    settings.age.should == 42
  end
end
