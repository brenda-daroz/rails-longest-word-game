class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    alphabet = ("a".."z").to_a
    @letters = 9.times.map do
      alphabet.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters]

    @result = run_game(@word, @letters)
  end

  private

  def word_in_grid?(word, letters)
    result = true
    letters_arr = letters.upcase.split(" ")
    word_arr = word.upcase.split("")

    word_arr.each do |char|
      if (index = letters_arr.find_index(char))
        letters_arr.delete_at(index)
      else
        result = false
      end
    end
    return result
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response_serialized = URI.open(url).read
    response = JSON.parse(response_serialized)

    response["found"]
  end

  def run_game(word, letters)
    word_in_grid = word_in_grid?(word, letters)

    if word_in_grid && english_word?(word)
      return "Congratulations! #{word.upcase} is a valid english word."
    elsif !word_in_grid
      return "Sorry, but #{word.upcase} can't be build out of #{letters.upcase}"
    else
      return "Sorry, #{word.upcase} does not seem to be an english word..."
    end
  end
end
