class Board
  def initialize
    @empty = "O"
    @p1 = "\u26AA"
    @p2 = "\u26AB"
    @win_chip = "\u26D4"
    @board_hash = {
      row1: Array.new(7, nil),
      row2: Array.new(7, nil),
      row3: Array.new(7, nil),
      row4: Array.new(7, nil),
      row5: Array.new(7, nil),
      row6: Array.new(7, nil)    
    }

    @test_hash = {
      row1: Array.new(7, 1),
      row2: Array.new(7, 1),
      row3: Array.new(7, 1),
      row4: Array.new(7, 1),
      row5: Array.new(7, 1),
      row6: Array.new(7, 1)
    }

  end

  def state
    board_state = {}
    @board_hash.each do |key, row_array|
      to_render = []
      row_array.each do |elem|
        case elem
        when nil then to_render << @empty
        when 1 then to_render << @p1
        when 2 then to_render << @p2
        end
      end
      board_state[key] = to_render
    end
    board_state
  end

  def prepare_render
    for_render = {}
    self.state.each { |key, val| for_render[key] = val.join(" ") }
    for_render
  end

  def render_board
    puts "1 2 3 4 5 6 7"
    puts "-------------"
    prepare_render.each {|key, val| puts "#{val}"}
  end

  def change_state(player, position)
    success = false
    @board_hash.each do |row, arr|
      next if arr[position-1]
      arr[position-1] = player
      success = true
      break
    end
    return @board_hash if success
    return nil
  end

  def win?(player, position)
    return true if horizontal?(player)
    return true if vertical?(player, position)
    return true if diagonal?(player, position)
    false
  end

  def horizontal?(player)
    win = false
    @board_hash.each do |row, array|
      if array.count(nil) <= 3 && array.count(player) >= 4
        array.each_cons(4) {|a, b, c, d| win = true if (a == b && b == c && c == d)}
        break if win
      end     
    end
    win
  end

  def vertical?(player, position)
    win = false
    chip_counter = 0
    @board_hash.each do |row, array|
      array[position-1] == player ? chip_counter += 1 : chip_counter = 0
      win = true if chip_counter == 4
      break if win
    end
    win
  end

  def diagonal?(player, position)
    y = position - 1
    x = -1
    @board_hash.each { |row, array| x += 1 if array[y] == 1 || array[y] == 2}
    return true if check_ad_diagonal(x, y, player) || check_bc_diagonal(x, y, player)
    false

    # Diagonal marker reference
    # A\  /B
    #   \/
    #   /\
    # C/  \D
  end

  def check_ad_diagonal(x, y, player)
    chip_counter = 1
    x_save = x.dup
    y_save = y.dup
    
    # From A to D(x+ y+)
    status = true
    until chip_counter == 4 || !status
      x += 1
      y += 1
      if x < 0 || y < 0 || x > 5 || y > 6
        status = false
        break
      end
      check_row(x, y, player) ? chip_counter += 1 : status = false
    end

    # From D to A (x- y-)
    if chip_counter < 4
      status = true
      x = x_save
      y = y_save
      until chip_counter == 4 || !status
        x -= 1
        y -= 1
        if x < 0 || y < 0 || x > 5 || y > 6
          status = false
          break
        end
        check_row(x, y, player) ? chip_counter += 1 : status = false
      end
    end
    chip_counter == 4 ? true : false
  end

  def check_bc_diagonal(x, y, player)
    chip_counter = 1
    x_save = x.dup
    y_save = y.dup
    
    # From B to C (x+ y-)
    status = true
    until chip_counter == 4 || !status
      x += 1
      y -= 1
      if x < 0 || y < 0 || x > 5 || y > 6
        status = false
        break
      end
      check_row(x, y, player) ? chip_counter += 1 : status = false
    end

    # From C to B (x- y+)
    if chip_counter < 4
      status = true
      x = x_save
      y = y_save
      until chip_counter == 4 || !status
        x -= 1
        y += 1
        if x < 0 || y < 0 || x > 5 || y > 6
          status = false
          break
        end
        check_row(x, y, player) ? chip_counter += 1 : status = false
      end
    end
    chip_counter == 4 ? true : false
  end

  def check_row(coordinate_x, coordinate_y, player)
    key = "row#{coordinate_x+1}".to_sym
    @board_hash[key][coordinate_y] == player ? true : false
  end

  def clear
    system("clear")
  end

  def load_hash(hash) # For testing service
    @board_hash = hash
  end
end
