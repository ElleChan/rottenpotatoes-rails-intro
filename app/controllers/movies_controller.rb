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
    redirect = false
    
    @all_ratings = Movie.get_ratings
    if(params[:ratings_submit] && !params[:ratings].nil?)
        @checked_ratings = params[:ratings].keys
        session[:ratings] = params[:ratings]
        session[:ratings_submit] = params[:ratings_submit]
    elsif(!session[:ratings].nil?)
         params[:ratings] = session[:ratings]
         params[:ratings_submit] = session[:ratings_submit]
        redirect = true
    else
        @checked_ratings = @all_ratings
    end
    
    if(params[:header_clicked])
        header_clicked = params[:header_clicked]
        session[:header_clicked] = header_clicked
    elsif(session[:header_clicked])
        header_clicked = session[:header_clicked]
        redirect = true
    else
        header_clicked = ""
    end
    
    if(redirect)
        flash.keep
        session.clear
        redirect_to movies_path({:header_clicked => header_clicked, :ratings => params[:ratings], :ratings_submit => params[:ratings_submit]})
    else
        if(header_clicked == "title")
          @movies = Movie.where('rating IN (?)', @checked_ratings).order(:title)
          @title_class = 'hilite'    
      elsif(header_clicked == "release_date")
          @movies = Movie.where('rating IN (?)', @checked_ratings).order(:release_date)
          @release_class = 'hilite'
      else
          @movies = Movie.where('rating IN (?)', @checked_ratings)     
      end
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
