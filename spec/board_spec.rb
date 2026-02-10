require './lib/board'

describe Board do
  let(:board) { Board.new }

  context "Should render board" do
    it "should prepare board state" do
      expected = {
        row1: ["O", "O", "O", "O", "O", "O", "O"],
        row2: ["O", "O", "O", "O", "O", "O", "O"],
        row3: ["O", "O", "O", "O", "O", "O", "O"],
        row4: ["O", "O", "O", "O", "O", "O", "O"],
        row5: ["O", "O", "O", "O", "O", "O", "O"],
        row6: ["O", "O", "O", "O", "O", "O", "O"]
      }
      expect(board.state).to eq expected
    end

    it "should prepare board for printing" do
      expected = {
        row1: "O O O O O O O",
        row2: "O O O O O O O",
        row3: "O O O O O O O",
        row4: "O O O O O O O",
        row5: "O O O O O O O",
        row6: "O O O O O O O"
      }
      expect(board.prepare_render).to eq expected
    end
  end

  context "should change board state" do
    it "handles player 1 action" do
      expected = {
        row1: [1, nil, nil, nil, nil, nil, nil],
        row2: [nil, nil, nil, nil, nil, nil, nil],
        row3: [nil, nil, nil, nil, nil, nil, nil],
        row4: [nil, nil, nil, nil, nil, nil, nil],
        row5: [nil, nil, nil, nil, nil, nil, nil],
        row6: [nil, nil, nil, nil, nil, nil, nil]
      }
      expect(board.change_state(1, 1)).to eq expected
    end

    it "handles player 2 action" do
      expected = {
        row1: [nil, nil, nil, nil, nil, nil, 2],
        row2: [nil, nil, nil, nil, nil, nil, nil],
        row3: [nil, nil, nil, nil, nil, nil, nil],
        row4: [nil, nil, nil, nil, nil, nil, nil],
        row5: [nil, nil, nil, nil, nil, nil, nil],
        row6: [nil, nil, nil, nil, nil, nil, nil]
      }
      expect(board.change_state(2, 7)).to eq expected
    end

    it "returns nil if chosen column oversaturated" do
      6.times {board.change_state(1, 1)}
      expect(board.change_state(1, 1)).to eq nil      
    end
  end

  context "should detect winning condition" do
    it "detect horizontal winning line" do
      i = 1
      4.times {board.change_state(1, i); i+=1}
      expect(board.win?(1, 4)).to eq true
    end

    it "detect vertical winning line" do
      4.times {board.change_state(1, 1)}
      expect(board.win?(1, 1)).to eq true
    end

    it "detect diagonal winning line" do
      3.times {board.change_state(2, 1)}
      board.change_state(1, 1)
      3.times {board.change_state(1, 2)}
      2.times {board.change_state(1, 3)}
      board.change_state(1, 4)
      expect(board.win?(1, 4)).to eq true
    end
  end

  context "check row method" do
    it "Возвращает true когда чип игрока найден по координатам" do
      3.times {board.change_state(1, 2)}
      expect(board.check_row(2, 1, 1)).to eq true
    end

    it "Возвращает false когда чип игрока НЕ найден по координатам" do
      3.times {board.change_state(2, 2)}
      expect(board.check_row(1, 1, 1)).to eq false     
    end
  end

  context "check diagonal method for ABOVE sector" do 
    let(:search_area) { "above" }

# Test hash
        # row1: "X F F F F F X",
        # row2: "O X X F X X O",
        # row3: "O O X X X O O",
        # row4: "O O X X X O O",
        # row5: "O O O O O O O",
        # row6: "O O O O O O O"

    test_hash = {
        row1: [1, 5, 5, 5, 5, 5, 1],
        row2: [nil, 1, 1, 5, 1, 1, nil],
        row3: [nil, nil, 1, 1, 1, nil, nil],
        row4: [nil, nil, 1, 1, 1, nil, nil],
        row5: [nil, nil, nil, nil, nil, nil, nil],
        row6: [nil, nil, nil, nil, nil, nil, nil]      
    }

    it "ABOVE: Can verify RIGHT winning diagonal" do
      board.load_hash(test_hash)
      expect(board.check_diagonal(search_area, "right", 3, 3, 1)).to eq true
    end

    it "ABOVE: Can verify RIGHT unfinished diagonal" do
      board.load_hash(test_hash)
      expect(board.check_diagonal(search_area, "right", 3, 2, 1)).to eq false
    end 

    it "ABOVE: Can verify LEFT winning diagonal" do
      board.load_hash(test_hash)
      expect(board.check_diagonal(search_area, "left", 3, 3, 1)).to eq true
    end

    it "ABOVE: Can verify LEFT unfinished diagonal" do
      board.load_hash(test_hash)
      expect(board.check_diagonal(search_area, "left", 3, 4, 1)).to eq false
    end
  end

  context "check diagonal method for BELOW sector" do 
    let(:search_area) { "below" }

    test_hash = {
        row1: [5, 5, 5, 5, 5, 5, 5],
        row2: [5, 5, 5, 5, 5, 5, 5],
        row3: [5, 5, 1, 1, 1, 5, 5],
        row4: [5, 5, 1, 1, 1, 5, 5],
        row5: [5, 1, 1, 5, 1, 1, 5],
        row6: [1, 5, 5, 5, 5, 5, 1]     
    }
    it "BELOW: Can verify RIGHT winning diagonal" do
      board.load_hash(test_hash)
      expect(board.check_diagonal(search_area, "right", 2, 3, 1)).to eq true
    end

    it "BELOW: Can verify RIGHT unfinished diagonal" do
      board.load_hash(test_hash)
      expect(board.check_diagonal(search_area, "left", 2, 2, 1)).to eq false
    end 

    it "BELOW: Can verify LEFT winning diagonal" do
      board.load_hash(test_hash)
      expect(board.check_diagonal(search_area, "right", 2, 3, 1)).to eq true
    end

    it "BELOW: Can verify LEFT unfinished diagonal" do
      board.load_hash(test_hash)
      expect(board.check_diagonal(search_area, "left", 2, 4, 1)).to eq false
    end
  end

end