class Fake
  def initialize
    @ec2_client = Aws::EC2::Client.new(region: "us-east-1") # just to try to simulate the problem 
  end

  def fake_message
    "message fake"
  end
end