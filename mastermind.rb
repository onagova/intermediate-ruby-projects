module Mastermind
  class Board
    attr_reader :secret_code, :remaining_guess_chances,
                :latest_guess_code, :latest_guess_feedback

    def initialize(secret_code)
      @secret_code = secret_code
      @remaining_guess_chances = 12
      @latest_guess_code = nil
      @latest_guess_feedback = nil
    end

    def get_guess_feedback(guess_code)
      @remaining_guess_chances -= 1
      @latest_guess_code = guess_code
      @latest_guess_feedback = GuessFeedback.new(@secret_code, guess_code)
    end
  end

  class Code
    attr_reader :value

    def initialize(str)
      @value = str
    end

    def arr
      @value.split('')
    end

    def to_s
      @value
    end

    def self.get_instance(str)
      unless str.length == 4
        raise CustomError.new("Code must be four digits long: #{str}")
      end

      unless str.match? /^[1-6]{4}$/
        raise CustomError.new(
          "Each digit of code must be a number between 1 and 6 (inclusive): #{str}"
        )
      end

      self.new(str)
    end
  end

  class GuessFeedback
    attr_reader :correct_right_digit, :correct_wrong_digit

    def initialize(code, guess_code)
      @correct_right_digit = 0
      @correct_wrong_digit = 0

      code_arr = code.arr
      guess_code_arr = guess_code.arr

      guess_code_arr.each_with_index do |n, i|
        if code_arr[i] == n
          @correct_right_digit += 1
          code_arr[i] = nil
          guess_code_arr[i] = nil
        end
      end

      code_arr = code_arr.reject(&:nil?)
      guess_code_arr = guess_code_arr.reject(&:nil?)

      guess_code_arr.each_with_index do |n, i|
        if code_arr.include? n
          @correct_wrong_digit += 1
          code_arr[code_arr.index(n)] = nil
          guess_code_arr[i] = nil
        end
      end
    end

    def to_s
      right_digit_s = @correct_right_digit == 1 ? '' : 's'
      wrong_digit_s = @correct_wrong_digit == 1 ? '' : 's'
      "[FEEDBACK]\n" +
      "#{@correct_right_digit} correct number#{right_digit_s} " +
      "in right digit#{right_digit_s}\n" +
      "#{@correct_wrong_digit} correct number#{wrong_digit_s} " +
      "in wrong digit#{wrong_digit_s}\n" +
      '[END-OF-FEEDBACK]'
    end

    def ==(other)
      self.correct_right_digit == other.correct_right_digit &&
      self.correct_wrong_digit == other.correct_wrong_digit
    end
  end

  class GameManager
    def play
      puts "In this mastermind a valid code is a four digits " +
           "of number between 1 and 6 (inclusive) " +
           "e.g. 1111, 1112, 6665, 6666"
      puts ''

      codemaker, codebreaker = get_codemaker_codebreaker
      puts ''

      puts 'Codemaker must make a secret code.'
      board = Board.new(codemaker.make_secret_code)
      codemaker.board = board
      codebreaker.board = board
      puts ''

      while board.remaining_guess_chances > 0
        begin
          puts "#{board.remaining_guess_chances} chances remaining..."
          guess_code = codebreaker.make_guess_code
          feedback =  board.get_guess_feedback(guess_code)
          puts feedback
          puts ''
          if feedback.correct_right_digit == 4
            puts "Game Over! #{codebreaker.name} cracked the secret code!"
            return
          end
        rescue CustomError => e
          puts e
          puts 'Try again...'
          puts ''
          retry
        end
      end

      puts "GameOver! #{codebreaker.name} didn't crack the secret code: " +
           "#{board.secret_code}"
    end

    private

    def get_codemaker_codebreaker
      role = 0
      loop do
        print 'Select your role (1)Codemaker or (2)Codebreaker: '
        role_response = gets.chomp
        if role_response.match? /^[1-2]$/
          role = role_response.to_i
          break
        else
          puts "Invalid input: #{role_response}"
          puts 'Try again...'
          puts ''
        end
      end

      case role
      when 1 then [Human.new, Bot.new]
      when 2 then [Bot.new, Human.new]
      end
    end
  end

  class Player
    attr_accessor :board
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def make_secret_code; end
    def make_guess_code; end
  end

  class Human < Player
    def initialize(name='You')
      super
    end

    def make_secret_code
      make_code('Enter a secret code: ')
    end

    def make_guess_code
      make_code('Enter your guess: ')
    end

    private

    def make_code(prompt='Enter a code: ')
      print prompt
      Code.get_instance(gets.chomp)
    end
  end

  class Bot < Player
    def initialize(name='Bot')
      super
      @possible_codes = nil
    end

    def make_secret_code
      puts 'Bot has made a secret code.'
      make_code
    end

    def make_guess_code
      if @possible_codes == nil
        generate_possible_codes
        code = Code.new('1122')
      else
        guess_code = board.latest_guess_code
        latest_feedback = board.latest_guess_feedback
        @possible_codes = @possible_codes.select do |code|
          GuessFeedback.new(code, guess_code) == latest_feedback
        end
        code = @possible_codes[0]
      end

      puts "Bot has made a guess: #{code}"
      code
    end

    private

    def make_code
      code_str = (1..4).reduce('') { |a, _| a += (rand(6) + 1).to_s }
      Code.get_instance(code_str)
    end

    def generate_possible_codes
      arr = ['']
      4.times { arr = Bot.get_six_variation(arr) }
      @possible_codes = arr.map { |str| Code.new(str) }
    end

    def self.get_six_variation(arr)
      arr.reduce([]) do |a, str|
        (1..6).each { |i| a << str + i.to_s }
        a
      end
    end
  end

  class CustomError < StandardError
    def initialize(msg='Mastermind error')
      super("[ERROR] #{msg}")
    end
  end
end

Mastermind::GameManager.new.play
