require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
    # @letters = ['h','e','l','l','v','o','t','i','e','s']
    if !params[:total_score]
      @total_score = 0
    else
      @total_score = params[:total_score]
    end
  end

  def score
    @letters = params[:grid].split('')
    if from_the_array
      english_word
      if @result['found']
        upscore
        @score = "Congratulation! #{params[:word].upcase} is an English word."
      else
        @score = "Sorry..#{params[:word].upcase} is not an English word..."
      end
    else
      @score = "Sorry #{params[:word].upcase} can't be built out of #{@letters.join(', ')}"
    end
  end

  private

  def from_the_array
    params[:word].split('').each do |letter|
      if @letters.include?(letter)
        @letters.delete_at(@letters.index(letter))
      else
        false
      end
      return true
    end
  end

  def english_word
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    @result = JSON.parse(open(url).read)
  end

  def upscore
    @total_score = params['total_score'].to_i + @result['length']
  end
end
