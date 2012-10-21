class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@all_ratings = Movie.allRatings
	@movies = Movie
	headers = ["title","release_date"]	

	#Check values from session if there aren't params
	unless params.has_key?(:ratings) or params.has_key?(:order_by)
		
		params[:ratings] = params.has_key?(:ratings) ? params[:ratings] : session[:ratings]
		params[:order_by] = params.has_key?(:order_by) ? params[:order_by] : session[:order_by]
	
		if session.has_key?(:ratings) or session.has_key?(:order_by)
			flash.keep
			redirect_to movies_path(params)
		end
	end

	#Check if the array checked had been created before
	@checkeds  =  @checkeds ? @checkeds : Hash.new{"true"}

	# Check whether some filters or not
	if params[:ratings].is_a? Enumerable and params[:ratings].length > 0
		@checkeds = params[:ratings]
	end
	

	if @checkeds.length > 0
		session[:ratings] =  @checkeds
		@movies = @movies.where(rating: @checkeds.keys)
	end

	if params[:order_by].eql? "title" or params[:order_by].eql? "release_date"
		session[:order_by] =  params[:order_by]
		@movies = @movies.order("#{params[:order_by]} ASC")
	end
    	
	@movies = @movies.all
	

	# Check whether hilite or not
	headers.each do |head|
			nameClass = "class_#{head}"
			if head.eql? params[:order_by]
				flash[nameClass.to_sym] = "hilite"
			else
				flash[nameClass.to_sym] = ""
			end
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
