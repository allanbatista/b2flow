require 'rails_helper'

RSpec.describe Token do
  context ".encode/.decode" do
    it "should encode and decode correct" do
      token = Token.encode({name: 'allan batista', age: 28})

      expect(token).to be_a(String)

      expect(Token.decode(token)).to eq({"name" => "allan batista", "age" => 28})
    end

    it "should return nil when time expired" do
      token = Token.encode({name: 'allan batista', age: 28}, Time.now + 1.second)

      sleep(2) # sleep 1.1 seconds

      expect(Token.decode(token)).to be_nil
    end
  end
end