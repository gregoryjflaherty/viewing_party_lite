class Users::MoviesController < ApplicationController

  def show
    @user = current_user
    if params[:results] == 'true'
      @movie = MovieFacade.get_movie(params[:id])
      @cast = MovieFacade.get_10_cast(@movie.api_id)
      @reviews = MovieFacade.get_reviews(@movie.api_id)
    else
      @movie_db = Movie.find(params[:id])
      @movie = MovieFacade.get_movie(@movie_db.api_id)
      @cast = MovieFacade.get_10_cast(@movie_db.api_id)
      @reviews = MovieFacade.get_reviews(@movie_db.api_id)
    end
  end

  def index
    @user = current_user
    if params[:q] == 'top%20rated'
      @results = MovieFacade.top_twenty
    else
      @results = MovieFacade.search(params[:search])
      @search = params[:search]
    end
  end
end
