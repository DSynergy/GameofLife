require_relative 'GameofLife'
require 'minitest/autorun'
require 'minitest/pride'

class GameofLifeTest < Minitest::Test
  #False = Dead
  #True = Alive

  def test_it_creates_a_3x3_board
    game = GameofLife.new(3,3)
    assert_equal [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]], game.board
  end

  def test_it_creates_a_2x2_board
    game = GameofLife.new
    assert_equal [[nil,nil], [nil, nil]], game.board
  end

  def test_cells_can_be_created_alive
    game = GameofLife.new(2,2)
    game.toggle_cell(0,0)
    assert_equal [[true, nil], [nil, nil]], game.board
  end

  def test_cells_can_be_toggled_dead
    game = GameofLife.new(2,2)
    game.toggle_cell(0,0)
    game.toggle_cell(0,0)
    assert_equal [[false, nil], [nil, nil]], game.board
  end

  def test_a_cell_knows_its_neigbours_are_nil
    game = GameofLife.new(2,2)
    assert_equal 0, game.total_alive_neighbours(0,0)
  end

  def test_a_cell_knows_its_neigbours_are_alive
    game = GameofLife.new(3,3)
    game.toggle_cell(0,0)
    assert_equal 1, game.total_alive_neighbours(1,1)
  end

  def test_any_cell_with_zero_live_neighbours_dies
    game = GameofLife.new(3,3)
    game.toggle_cell(1,1)
    game.run_game
    assert_equal false, game.board[1][1]
  end

  def test_any_cell_with_one_live_neighbours_dies
    game = GameofLife.new(3,3)
    game.toggle_cell(1,1)
    game.toggle_cell(1,2)
    game.run_game
    assert_equal false, game.board[1][1]
    assert_equal false, game.board[1][2]
  end

  def test_any_cell_with_two_live_neighbours_lives
    game = GameofLife.new(3,3)
    game.toggle_cell(1,1)
    game.toggle_cell(1,2)
    game.toggle_cell(2,1)
    assert_equal true, game.board[1][1]
  end

  def test_any_cell_with_three_live_neighbours_lives
    game = GameofLife.new(3,3)
    game.toggle_cell(1,1)
    game.toggle_cell(1,2)
    game.toggle_cell(2,1)
    game.toggle_cell(2,2)
    assert_equal true, game.board[1][1]
  end

  def test_any_cell_with_four_live_neighbours_dies
    game = GameofLife.new(3,3)
    game.toggle_cell(1,1)
    game.toggle_cell(1,2)
    game.toggle_cell(2,1)
    game.toggle_cell(2,2)
    game.toggle_cell(0,1)
    game.run_game
    assert_equal false, game.board[1][1]
  end

  def test_any_dead_cell_with_three_live_neighbours_lives
    game = GameofLife.new(3,3)
    game.kill_cell(0,0)
    game.toggle_cell(1,1)
    game.toggle_cell(0,1)
    game.toggle_cell(1,0)
    game.run_game
    assert_equal true, game.board[0][0]
  end

  def test_generations
    game = GameofLife.new(3,3)
    assert_equal 0, game.generations
    game.run_game
    assert_equal 1, game.generations
  end

  def test_total_population
    game = GameofLife.new(3,3)
    game.toggle_cell(1,1)
    game.toggle_cell(0,1)
    game.toggle_cell(1,0)
    game.run_game
    assert_equal 3, game.population
  end

end
