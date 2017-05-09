require 'open-uri'
require 'nokogiri'

class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_filter :set_cache_headers

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
    
        
    @url = []
    (2..5).each { |page|
      doc = Nokogiri::HTML(open("http://boards.4chan.org/mu/" + page.to_s))
  
      doc.xpath("//a[@class=\"replylink\"]").each { |node|
        thread = Nokogiri::HTML(open("http://boards.4chan.org/mu/" + node["href"]))
  
        thread.xpath("//blockquote[@class=\"postMessage\"]").each { | mu_post |
          mu_post.text.scan(/www\.youtube\.com\/watch\?v=(([a-zA-Z0-9]){11})/).each { | yt |
            @url << Regexp.last_match[1] if Regexp.last_match
          }    
        }
      }
    }
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    #@song = Song.new

  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render action: 'show', status: :created, location: @song }
      else
        format.html { render action: 'new' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:title, :url)
    end
    
   def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
