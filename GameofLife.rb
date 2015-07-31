require_relative 'cell'
require 'colorize'

class GameofLife
  attr_reader :board,
              :width,
              :height,
              :time,
              :generations,
              :population

  def initialize
    input
    @board = Array.new(width) {Array.new(height)}
    @width = width
    @height = height
    @population = 0
    @time = time
    @generations = 0
  end

  def input
    p "Starting board height in cells? 50 is a good default"
    @height = gets.chomp.to_i
    p "Starting board width in cells? 50 is a good default"
    @width = gets.chomp.to_i
    p "Starting board time in seconds? 0.25 is a good default"
    @time = gets.chomp.to_f
  end

  def randomly_generate_board
    board.each_with_index do |array, x|
      array.each_with_index do |cell, y|
        if rand(100) % 2 == 0
          toggle_cell(x,y)
        else
          kill_cell(x,y)
        end
      end
    end
  end

  def toggle_cell(x,y)
    board[x][y] == nil || board[x][y] == false ? board[x][y] = true : board[x][y] = false
  end

  def kill_cell(x,y)
    board[x][y] = false
  end

  def birth_cell(x,y)
    board[x][y] = true
  end

  def total_alive_neighbours(x,y)
    cells = []
    cells << Cell.new(self, x-1, y-1)
    cells << Cell.new(self, x-1, y+1)
    cells << Cell.new(self, x-1, y)
    cells << Cell.new(self, x, y-1)
    cells << Cell.new(self, x, y+1)
    cells << Cell.new(self, x+1, y-1)
    cells << Cell.new(self, x+1, y)
    cells << Cell.new(self, x+1, y+1)
    cells.map(&:alive?).count(true)
  end

  def run_game
    @population = 0
    @generations +=1
    board.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        check_underpopulation(x,y)
        check_overcrowding(x,y)
        check_reproduction(x,y)
      end
    end
    check_total_population
    print_game
  end

  def print_game
    system "clear"
    board.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        if cell == false
          print  "  "
        else
          print "\e[32m#{'█'}\e[0m "
        end
      end
      puts
    end
    puts "Current Generation: #{@generations}"
    puts "Current Population: #{@population}"
  end

  def check_underpopulation(x,y)
    if total_alive_neighbours(x,y) < 2
      kill_cell(x,y)
    end
  end

  def check_overcrowding(x,y)
    if total_alive_neighbours(x,y) > 3
      kill_cell(x,y)
    end
  end

  def check_reproduction(x,y)
    if total_alive_neighbours(x,y) == 3
      birth_cell(x,y)
    end
  end

  def check_total_population
    board.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        if cell == true
          @population += 1
        end
      end
    end
  end

end

#comment out code below to run tests
game = GameofLife.new
game.randomly_generate_board
while true
  game.run_game
  sleep(game.time)
end
