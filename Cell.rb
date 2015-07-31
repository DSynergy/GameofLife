class Cell
  def initialize(game, x, y)
    @game = game
    @board = game.board
    @x = x
    @y = y
  end

  def alive?
    if @x >= 0 && @x < @game.width
       @board[@x][@y] == 1 ? true : false
    else
      nil
    end
  end
end
