require './lib/game'

describe Game do
  let(:game) { Game.new }
  context "Should have player names" do
    it "Have player name 1" do
      expect(game.player1_name?).to eq "Bob"
    end

    it "Have player name 2" do
      expect(game.player2_name?).to eq "Rob"
    end
  end
end