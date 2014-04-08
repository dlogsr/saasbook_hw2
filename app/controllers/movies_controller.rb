class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if params[:clear]
      reset_session
    end


    #check the params here for the session requirements
    @all_ratings = Movie.ratings
    redirect = false
    redirection = Hash.new
    if params[:ratings]
      @checked_ratings = params[:ratings].keys
      @movies = Movie.find_all_by_rating @checked_ratings
      session[:ratings] = params[:ratings]
    elsif  session[:ratings]
      redirect = true
      #redirection[:ratings] = session[:ratings]
      #redirect_to movies_path(:ratings => session[:ratings])
    else
      @movies = Movie.all
    end

    order = params[:order]
    if order == 'title'
      @movies = Movie.find(:all, :order =>'title')
      @title_ordered = true
      session[:order] = params[:order]
    elsif order == 'release_date'
      @movies = Movie.find(:all, :order => 'release_date')
      @date_ordered = true
      session[:order] = params[:order]
    else
      if order == 'title'
        redirect = true
        #redirection[:order] = 'title'
        #redirect_to movies_path(:order => 'title')
      elsif order == 'release_date'
        redirect = true
        #redirection[:order] = 'release_date'
        #redirect_to movies_path(:order => 'release_date')
      end
    end

    if redirect
      redirect_to movies_path(session)
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
