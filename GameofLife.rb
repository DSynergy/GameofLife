require_relative 'cell'
require 'colorize'

class GameofLife
  attr_reader :board, :width, :height

  def initialize(width=2, height=2)
    @board ||= Array.new(width) {Array.new(height)}
    @width = width
    @height = height
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
    board[x][y] == nil || board[x][y] == 0 ? board[x][y] = 1 : board[x][y] = 0
  end

  def kill_cell(x,y)
    board[x][y] = 0
  end

  def birth_cell(x,y)
    board[x][y] = 1
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
    board.each_with_index do |array, x|
      array.each_with_index do |cell, y|
        check_underpopulation(x,y)
        check_overcrowding(x,y)
        check_reproduction(x,y)
      end
    end

    puts "========================="
    board.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        if cell == 0
          print  " "
        else
          print "\e[32m#{'X'}\e[0m "
        end
      end
      puts
    end
    puts "========================="
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

end

game = GameofLife.new(ARGV[0].to_i, ARGV[1].to_i)
game.randomly_generate_board

while true
  game.run_game
  sleep(0.5)
end
