module TicTacToe
  O_MARK = 'O'
  X_MARK = 'X'

  class Board
    attr_reader :locked, :winner

    def initialize
      @cells =
        [
          [' ', ' ', ' '],
          [' ', ' ', ' '],
          [' ', ' ', ' ']
        ]
      @locked = false
      @winner = ' '
    end

    def make_mark(mark, coord)
      raise CustomError.new('Board is already locked') if locked

      unless mark.upcase == O_MARK || mark.upcase == X_MARK
        raise CustomError.new("#{mark} mark is invalid")
      end

      x = coord.x
      y = coord.y

      if (x < 0 || x > 2) || (y < 0 || y > 2)
        raise CustomError.new("#{coord} is out of bounds")
      end

      unless @cells[x][y] == ' '
        raise CustomError.new("#{coord} is not empty")
      end

      @cells[x][y] = mark.upcase
      update_states(mark.upcase, coord)
    end

    def to_s
      "   A   B   C\n" +
      "1 [#{@cells[0][0]}] [#{@cells[1][0]}] [#{@cells[2][0]}]\n" +
      "2 [#{@cells[0][1]}] [#{@cells[1][1]}] [#{@cells[2][1]}]\n" +
      "3 [#{@cells[0][2]}] [#{@cells[1][2]}] [#{@cells[2][2]}]"
    end

    private

    def update_states(mark, coord)
      if @cells.none? { |col| col.any?(' ') }
        @locked = true
        return
      end

      x = coord.x
      y = coord.y

      col = (0..2).map { |i| @cells[x][i] }
      return if try_decide_winner(col, mark)

      row = (0..2).map { |i| @cells[i][y] }
      return if try_decide_winner(row, mark)

      unless (x - y).abs == 1 #None diagonal coord
        dia1 = (0..2).map { |i| @cells[i][i] }
        return if try_decide_winner(dia1, mark)

        dia2 = (0..2).map { |i| @cells[2 - i][i] }
        return if try_decide_winner(dia2, mark)
      end
    end

    def try_decide_winner(arr, mark)
      if arr.all?(mark)
        @locked = true
        @winner = mark
        true
      elsif
        false
      end
    end
  end

  class LetterNumberCoordinate
    A_ORD = 'A'.ord
    attr_reader :x, :y

    def initialize(coord)
      @coord = coord.upcase
      match_data = @coord.match /([a-z])(\d+)/i
      @x = match_data[1].ord - A_ORD
      @y = match_data[2].to_i - 1
    end

    def to_s
      @coord
    end

    def self.get_instance(str)
      if str.match? /^[a-z]\d+$/i
        self.new(str)
      else
        raise CustomError.new("Invalid coordinate string: #{str}")
      end
    end
  end

  class GameManager
    def initialize
      @board = Board.new
      @next_mark = O_MARK
    end

    def play
      puts '**Enter letter-number coordinate (e.g. B2) to select your marking position**'

      loop do
        begin
          print "#{@next_mark}'s turn to mark: "
          str = gets.chomp
          coord = LetterNumberCoordinate.get_instance(str)
          @board.make_mark(@next_mark, coord)
        rescue CustomError => e
          puts e
          puts 'Try again...'
          retry
        end

        puts @board

        if @board.locked
          case @board.winner
          when O_MARK, X_MARK then puts "Game Over! #{@board.winner} wins!"
          else puts 'Game Over! It\'s a tie!'
          end

          break
        else
          @next_mark = @next_mark == O_MARK ? X_MARK : O_MARK
        end
      end
    end
  end

  class CustomError < StandardError
    def initialize(msg='Tic Tac Toe error')
      super("[ERROR] #{msg}")
    end
  end
end

TicTacToe::GameManager.new.play
