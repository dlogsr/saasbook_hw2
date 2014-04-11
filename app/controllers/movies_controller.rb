class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.ratings
    @movies = Movie.all
    redirect = false
    if params[:ratings]
      session[:ratings] = params[:ratings]
      redirection_ratings = params[:ratings] #could be session[:ratings] too

    elsif  session[:ratings]
      redirection_ratings = session[:ratings]
      redirect = true
    else
      @movies = Movie.all
    end

    if params[:order] == 'title'
      @title_ordered = true
      session[:order] = params[:order]
      redirection_order = params[:order]
    elsif params[:order] == 'release_date'
      @date_ordered = true
      session[:order] = params[:order]
      redirection_order = params[:order]
    elsif session[:order]
      redirection_order = session[:order]
      redirect = true
    end

    if params[:clear]
      session.clear
    elsif redirect == true
      redirect = false
      redirect_to movies_path(:ratings => redirection_ratings, :order => redirection_order)
    else
      @movies = Movie.where(:rating => redirection_ratings.keys).find(:all, :order => redirection_order)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
