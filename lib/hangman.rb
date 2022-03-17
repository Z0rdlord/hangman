require 'yaml'

wordlist = File.open("hang_man_words.txt")
randomword = "foo"

until randomword.length > 4 and randomword.length <13
    randomword = File.readlines(wordlist).sample
end 

#This is for troubleshooting purposes to verify guesses working correctly
puts randomword 



class Game

    attr_accessor :word

   def initialize(randomword)  
    @word = randomword.split("")
    @word.pop
    @guess_remain = 8
    @board =[]
    @picked =[]
    @game_status = "In Progress"

    newOrSaved = 3
    
    until newOrSaved == "1" or newOrSaved == "2"
        puts "Press 1 for New game. \nPress 2 to load saved game"
        newOrSaved = gets.chomp
    end

    if newOrSaved == "1"
        create_board
        play_game
    elsif newOrSaved == "2"
        load_saved_game
        puts "Resuming Game. So far you have picked #{@picked} and have #{@guess_remain} guesses remaining"
        play_game
    end


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
    puts "Pick a letter\n"
    @guess = gets.chomp

    if @word.include?(@guess)    
        @word.each_with_index {|letter,index| (letter == @guess) ? @board[index] = @guess : " _" }
        @picked << @guess
    else 
        @guess_remain -= 1
        puts "That letter is not in the word.\n"
        @picked << @guess
    end
    puts "Letters chosen so far are #{@picked}. You still have #{@guess_remain} guesses left.\n"
    
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
    
    
    until @game_status != "In Progress" do
        
        take_turn
        check_status
        print_board
        save_game
    end
    
end


#serialize game class and export to yaml file

    def to_yaml
        YAML.dump(
            'word' =>@word,
            'guess_remain' =>@guess_remain,
            'board' => @board,
            'picked' => @picked
        )
    end 

    
    def load_saved_game
        puts "Enter a file name"
        savedgame = gets.chomp
        savedgame = "#{savedgame}.yaml"
        
        file = YAML.safe_load(File.read("saved_games/#{savedgame}"))
        @word = file['word']
        @guess_remain =file['guess_remain']
        @board = file['board']
        @picked =file['picked']
    end


    def save_game
       saveGame = 'bar'
        
       until saveGame == 'y' or saveGame =='n' do
        puts "\nWould you like to save your game? Y/N"
       saveGame = gets.chomp.downcase    
       end

       if saveGame == 'y'
                    
            Dir.mkdir('saved_games') unless Dir.exist?('saved_games')

            puts 'Enter filename'
            filename = gets.chomp
            filename = "saved_games/#{filename}.yaml"

            File.open(filename,'w') do |file|
                file.puts to_yaml
            end
            @game_status = "Saved"
            puts
            puts "Goodbye"
        else
            @game_status
        end



    end


end 

Game.new(randomword)
