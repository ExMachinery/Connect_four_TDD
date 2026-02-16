class Board
  def initialize
    @empty = "\u26AB"
    @p1 = "\u26AA"
    @p2 = "\u26BD"
    @win_chip = "\u26D4"
    @board_hash = {
      row1: Array.new(7, nil),
      row2: Array.new(7, nil),
      row3: Array.new(7, nil),
      row4: Array.new(7, nil),
      row5: Array.new(7, nil),
      row6: Array.new(7, nil)    
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
        when 7 then to_render << @win_chip
        end
      end
      board_state[key] = to_render
    end
    board_state
  end

  def prepare_render
    for_render = {}
    self.state.each { |key, val| for_render[key] = val.join(" ") }
    # Mirrior
    for_render_mirrior = for_render.to_a.reverse.to_h
    for_render_mirrior
  end

  def render_board
    puts " 1  2  3  4  5  6  7 "
    puts "====================="
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

  def draw?
    draw_checker = @board_hash.map {|key, val| val.include?(nil)}
    return draw_checker.empty?
  end

  def horizontal?(player)
    win = false
    @board_hash.each do |row, array|
      if array.count(nil) <= 3 && array.count(player) >= 4
        chip_counter = 0
        array.each_with_index do |val, ind|
          val == player ? chip_counter += 1 : chip_counter = 0
          if chip_counter == 4
            4.times {|i| @board_hash[row][ind - i] = 7}
            win = true
          end
          break if win
        end
      end
    end
    win
  end

  def vertical?(player, position)
    win = false
    chip_counter = 0
    winning_rows = []
    @board_hash.each do |row, array|
      if array[position-1] == player
        chip_counter += 1
        winning_rows << row
      else
        chip_counter = 0
        winning_rows = []
      end
      win = true if chip_counter == 4
      break if win
    end
    if win
      winning_rows.each {|key| @board_hash[key][position-1] = 7}
    end
    win
  end

  def diagonal?(player, position)
    y = position - 1
    x = -1
    @board_hash.each { |row, array| x += 1 if array[y] == 1 || array[y] == 2}
    return true if check_diagonal(x, y, player)
    false
  end

  def check_diagonal(x, y, player)
    chip_counter = 1
    check_row(x, y, player)
    chip_counter = check_diagonal_cross(x, y, 1, -1, player, chip_counter)
    chip_counter = check_diagonal_cross(x, y, -1, 1, player, chip_counter) if chip_counter < 4
    return true if chip_counter >= 4
    clear_mess(player)
    chip_counter = 1
    check_row(x, y, player)
    chip_counter = check_diagonal_cross(x, y, 1, 1, player, chip_counter)
    chip_counter = check_diagonal_cross(x, y, -1, -1, player, chip_counter) if chip_counter < 4
    return true if chip_counter >= 4
    clear_mess(player)
    false  
  end

  def check_diagonal_cross(x, y, x_modify, y_modify, player, chip_counter)
    status = true
    until chip_counter == 4 || !status
      x += x_modify
      y += y_modify
      if x < 0 || y < 0 || x > 5 || y > 6
        status = false
        break
      end
      check_row(x, y, player) ? chip_counter += 1 : status = false
    end
    return chip_counter
  end

  def check_row(coordinate_x, coordinate_y, player)
    result = nil
    key = "row#{coordinate_x+1}".to_sym
    if @board_hash[key][coordinate_y] == player 
      result = true
      @board_hash[key][coordinate_y] = 7
    else
      result = false
    end
    result
  end
  
  def clear_mess(player)
    @board_hash.each do |row, array|
      array.each_with_index {|val, ind| @board_hash[row][ind] = player if val == 7}
    end
  end

  def load_hash(hash) # For testing service
    @board_hash = hash
  end
end
