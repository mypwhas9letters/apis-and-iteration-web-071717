require 'rest-client'
require 'json'
require 'pry'


def get_character_movies_from_api(character)
  #make the web request
  character_hash = web_request
  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  char_films = nil
  character_hash.each do |info|
    if info["name"] == character
      char_films = info["films"]
    end
  end

  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  filminfo = []
  char_films.each do |film|
    allfilms = RestClient.get(film)
    filminfo << JSON.parse(allfilms)
  end

  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.
  filminfo
end

def web_request
  all_characters = []
  last_url = nil

  response = JSON.parse(RestClient.get('http://www.swapi.co/api/people/'))

  until response["next"] == nil
    # concat the results to our all_characters array
    charlist = response["results"]
      charlist.each do |x|
        all_characters << x
      end
    next_url = response["next"]
    last_url = response["next"]
    response = JSON.parse(RestClient.get(next_url))
  end
  charlist = (JSON.parse(RestClient.get(last_url)))["results"]
  charlist.each do |x|
    all_characters << x
  end
  # tempURL = []
  # all_characters = RestClient.get('http://www.swapi.co/api/people/')
  # character_hash = JSON.parse(all_characters)
  # if character_hash["next"]
  #   tempURL << "http://www.swapi.co/api/people/" + character_hash["next"].split("/")[-1]

  #     tempURL.each do |url|
  #     all_characters = (RestClient.get(url))
  #     all_hashes = JSON.parse(all_characters)
  #   end
  # end
  # binding.pry
end


def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  #SIDE NOTE: films_hash is actually an array ...
  films_hash.each_with_index do |film, index|
    puts "#{index + 1}. #{film["title"]}"
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
