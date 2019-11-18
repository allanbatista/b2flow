require 'rails_helper'

RSpec.describe 'AppConfig' do
  before do
    @defaults = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]
  end

  it "should get default value" do
    expect(AppConfig.B2FLOW__TOKEN_SECRET).to eq(@defaults['B2FLOW__TOKEN_SECRET'])
  end

  it "should use env var when is defined" do
    ENV.update({'B2FLOW__TOKEN_SECRET' => "123"})
    expect(AppConfig.B2FLOW__TOKEN_SECRET).to eq("123")
  end
end