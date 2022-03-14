require 'yaml'

wordlist = File.open("hang_man_words.txt")
randomword = "foo"

until randomword.length > 4 and randomword.length <13
    randomword = File.readlines(wordlist).sample
end 

puts randomword 
puts randomword.length


class Game

    attr_accessor :word

   def initialize(randomword)  
    @word = randomword.split("")
    @word.pop
    @guess_remain = 8
    @board =[]
    @picked =[]
    @game_status = "In Progress"

   end 

   def create_board
    num_of_blanks = word.length

    num_of_blanks.times {
        @board << " _"
    }
    
  end 

  def print_board
    puts " #{@board.join}"
  end

  def take_turn
    puts 'Pick a letter'
    @guess = gets.chomp

    if @word.include?(@guess)    
        @word.each_with_index {|letter,index| (letter == @guess) ? @board[index] = @guess : " _" }
        @picked << @guess
    else 
        @guess_remain -= 1
        puts "That letter is not in the word. You have #{@guess_remain} guesses left"
        @picked << @guess
    end
    puts "Letters chosen so far are #{@picked}."
    print_board
  end

  def check_status
    if @board.include?(" _")
        if @guess_remain < 1
            puts "Game over, you ran out of guesses"
            @game_status = 'lose'
        end
    else
        if @board == @word
            puts "You win!"
            @game_status = 'win'
        else
            puts 'Error'
        end
    end
end

        
def play_game
    create_board
    print_board
    until @game_status != "In Progress" do
        take_turn
        check_status
        save_game
    end
    
end


#serialize game class and export to file

    def to_yaml
        YAML.dump({
            :word =>@word,
            :guess_remain =>@guess_remain,
            :board => @board,
            :picked => @picked
        })
    end 

    def self.from_yaml(string)
        data= YAML.load string
        self.new(data[:word],data[:guess_remain],data[:board],data[:picked])
    end


    def save_game
       puts "Would you like to save your game? Y/N"
       saveGame = gets.chomp

       if saveGame == 'Y'
                    
            Dir.mkdir('saved_games') unless Dir.exist?('saved_games')

            puts 'Enter filename'
            filename = gets.chomp
            filename = "saved_games/#{filename}"

            File.open(filename,'w') do |file|
                file.puts to_yaml
            end
            @game_status = "Saved"
        else
            @game_status
        end



    end


end 

gameTest = Game.new(randomword)
gameTest.play_game
#gameTest.save_game
#p gameTest
#p gameTest.word
#gameTest.create_board
#gameTest.print_board
#gameTest.take_turn
#gameTest.print_board