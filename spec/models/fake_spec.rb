RSpec.describe Fake do
  describe "#fake_message" do
    subject(:fake_message) { described_class.new.fake_message }

    it { is_expected.to eq "message fake" }
  end
end