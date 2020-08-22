require './tic_tac_toe.rb'
require './mastermind.rb'

selection = nil

while selection.nil?
  puts 'Please select a program to run:'
  puts '(1)Tic Tac Toe'
  puts '(2)Mastermind'
  print '=> '
  response = gets.chomp

  unless response.match? /^[1-2]$/
    puts "Invalid input: #{response}"
    puts 'Try again...'
    puts ''
  else
    selection = response.to_i
  end
end

puts ''
case selection
when 1 then TicTacToe::GameManager.new.play
when 2 then Mastermind::GameManager.new.play
end
