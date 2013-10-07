class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    if !params.include?('sort_by') and session.include?('sort_by')
        params['sort_by'] = session['sort_by']
        redirect = true
    end
    sort_by = params['sort_by']
    if sort_by == 'title_asc'
        order = "title ASC"
        @title_class = "hilite"
        @release_date_class = ""
    elsif sort_by == 'release_date_asc'
        order = "release_date ASC"
        @title_class = ""
        @release_date_class = "hilite"
    else
        order = ""
    end
    if !params.include?('ratings') and session.include?('ratings')
        params['ratings'] = session['ratings']
        redirect = true
    end
    @ratings = params['ratings']
    if redirect
        redirect_to :sort_by => sort_by, :ratings => @ratings
    end
    if @ratings == nil
        @ratings = {'G' => 1,'PG' => 1,'PG-13' => 1,'R' => 1, "NC-17" => 1}
    end
    @movies = Movie.find(:all, :order => order, :conditions => ["rating in (?)", @ratings.keys])
        
    
    @all_ratings = ['G','PG','PG-13','R', "NC-17"]
    session['sort_by'] = sort_by
    session['ratings'] = @ratings
    #debug_entry = @movies[0]
    #debug_entry['title'] = params.to_s
    #@movies.push(debug_entry)
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
    flash.keep
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
