class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings
    if(params[:ratings_submit])
        @checked_ratings = params[:ratings].keys unless params[:ratings].nil?
    else
        @checked_ratings = @all_ratings
    end
    
    @movies = Movie.all
    if(params[:title_clicked])
        @movies = Movie.order(:title)
        @title_class = 'hilite'      
    elsif(params[:release_date_clicked])
        @movies = Movie.order(:release_date)
        @release_class = 'hilite'
    else
        @movies = Movie.where('rating IN (?)', @checked_ratings)     
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
