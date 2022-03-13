require 'json'

wordlist = File.open("hang_man_words.txt")
randomword = "poop"

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

   end 

   def print_board
    num_of_blanks = word.length

    num_of_blanks.times {
        @board << " _"
    }
    puts @board
end 
   
   
   
   
   #def play
  
=begin
   ```displays  _ _ _ _ for each letter in the word "Pick a letter!"
   
   
   
   loops until guess = 0 or word is fully guessed
    gets a letter or save game 

        
    compares that letter to selected word, 
        if not in word guess -1
        if in word replace ALL blanks with applicable letter
    prints out _ _ _ _ and guesses remaining
    
    
```
 
=end        

#serialize game class and export to file - wrote for JSON but the yaml dump method will probably be better

    def to_json
        JSON.dump({
            :word =>@word,
            :guess_remain =>@guess_remain,
            :board => @board
        })
    end 

    def self.from_json(string)
        data= JSON.load string
        self.new(data['word'],data['guess_remain'],data['board'])
    end


end 

gameTest = Game.new(randomword)
p gameTest
puts gameTest.word
gameTest.print_board