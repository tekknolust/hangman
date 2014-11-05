
def secret_word
	words = File.readlines "dictionary.txt"
	possibilities = []
	words.each do |word|
		if word.length > 5 && word.length < 12
			possibilities.push(word.strip!)
		end
	end
	possibilities.sample
end

def save_game(secret, correct, incorrect)
	Dir.mkdir("saved_games") unless Dir.exists? "saved_games"

	if Dir.exists? "saved_games"
		id = (Dir['saved_games/*'].count {|file| File.file?(file)} +1)
	end

	filename = "saved_games/game_#{id}.rb"

	File.open(filename, 'w') do |file|
		file.puts secret, correct, incorrect
	end
end

def wrong(incorrect)
	if incorrect == []
		puts "Incorrect: none yet"
	else
		if incorrect.size >= 1
			puts "Incorrect: #{incorrect.join(" ")}"
			left = 6 - incorrect.size
			if left > 0
				puts "You have #{left} incorrect guesses left."
				puts "Would you like to save the game? (y/n)"
				save = gets.chomp.downcase
				if save == "y"
					save_game(secret, correct, incorrect)
				end
			end
		end
	end
end

correct = []
incorrect = []

puts "Hangman Initialized!"

secret = secret_word
secret.each_char do |letter|
	correct.push("_")
end

puts secret

#gameplay
for i in 0..(secret.length + 6)
	if incorrect.size < 6
		puts "The secret word is #{secret.length} characters long. 6 incorrect guesses means the game is over, and you lose."

		puts correct.join("")

		puts "Please enter a guess."
		guess = gets.chomp.downcase

		if (secret.downcase.index(guess) != nil)
			puts "You guessed right!"
			guess_position = []
			secret.downcase.length.times{|i| guess_position<<i if secret[i,1] == guess}
			guess_position.each do |x|
				correct[x] = guess
			end
		else
			puts "Sorry, that's incorrect."
			incorrect.push(guess)
		end

		puts correct.join("")
		puts wrong(incorrect)

		i = +1
	else
		puts "Sorry. Game over."
		break
	end
end

#only asks to save if incorrect
#need to be able to open saved
#need to break loop once won
#doesn't take in capitals - will say it's right, but doesn't put them in correct[]

