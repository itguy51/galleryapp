require 'securerandom'
require "net/http"
require "uri"
class ImagesController < ApplicationController
  # GET /images
  # GET /images.json
  def index
    #@images = Image.all
    @page = Page.find(params[:page_id])
    @images = @page.images

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @images }
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @image }
    end
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @page = Page.find(params[:page_id])
    @image = @page.images.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
  end

  # POST /images
  # POST /images.json
  def create
    #uri = "joshpruim.com/imagedata"
    @page = Page.find(params[:page_id])
    @image = @page.images.build(params[:image])
    #@image = Image.new(params[:image])
    uri = get_html_content("http://joshpruim.com/imagedata/path.txt")
    uuid = SecureRandom.hex
    uploaded_io = params[:image][:file]
    filen = Base64.encode64(uploaded_io.read)
    filename = uuid + File.extname(uploaded_io.original_filename)
    puts filename
    uri = URI.parse("http://" + uri + "/put.php?file=" + filename)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"data" => filen})
    response = http.request(request)
    puts response
    @image.file = uuid + File.extname(uploaded_io.original_filename)

    respond_to do |format|
      if @image.save
        format.html { redirect_to @page, :notice => 'Image was successfully created.' }
        format.json { render :json => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.json { render :json => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /images/1
  # PUT /images/1.json
  def update
    @image = Image.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to @image, :notice => 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end


  def get_html_content(requested_url)
    url = URI.parse(requested_url)
    full_path = (url.query.blank?) ? url.path : "#{url.path}?#{url.query}"
    the_request = Net::HTTP::Get.new(full_path)

    the_response = Net::HTTP.start(url.host, url.port) { |http|
      http.request(the_request)
    }

    raise "Response was not 200, response was #{the_response.code}" if the_response.code != "200"
    return the_response.body       
  end   
end
