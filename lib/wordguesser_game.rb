class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end

  def guess(letter)
    letter = letter.to_s.downcase

    if letter.nil? || letter.empty? || !letter.match?(/[a-z]/)
      raise ArgumentError, "Invalid guess."
    end

    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    if @word.include?(letter)
      @guesses += letter
      true
    else
      @wrong_guesses += letter
      true
    end
  end

  def word_with_guesses
    displayed_word = ''
    @word.each_char do |char|
      if @guesses.include?(char)
        displayed_word += char
      else
        displayed_word += '-'
      end
    end
    displayed_word
  end

  def check_win_or_lose
    if @word.chars.all? { |char| @guesses.include?(char) }
      return :win
    end

    if @wrong_guesses.length >= 7
      return :lose
    end
    :play
  end
end

