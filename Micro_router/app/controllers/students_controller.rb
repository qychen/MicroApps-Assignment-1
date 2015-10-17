require 'faraday'
require 'net/http'

class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  $url_ric = "http://45.55.44.135:4000/"
  $url_student = "http://159.203.110.135:3000/"
  $url_course = "http://localhost:5000/"

  #return student info back; via :get
  def info
    id1 = params[:id1]
    
	conn = Faraday.new(:url => 'http://159.203.110.135:3000') do |faraday|
	  faraday.request  :url_encoded             # form-encode POST params
	  faraday.response :logger                  # log requests to STDOUT
	  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
	end

	response = conn.post '/demo/info', { :id => id1 } 
	@result = response.body + "1122"

  end

  def ric
	#post to ric
	test = request.original_url
	@result = test
  end  

  def changelastname
  	if params[:flag]
    	url = $url_student + params[:id1] + "/changelastname"
    	@result = url 
    else
    	#resend to ric
    	redirect_to(:action => 'ric')
    end
  end

  def changefirstname
  end

  def addenrolled
	path = request.path
    id1 = params[:id1]
    id2 = params[:id2]
=begin
	conn = Faraday.new(:url => $url_ric) do |faraday|
	  faraday.request  :url_encoded             # form-encode POST params
	  faraday.response :logger                  # log requests to STDOUT
	  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
	end

	response = conn.get 'students/addenrolled', {:id1 => id1, :id2 => id2}
	@result = response.body
=end
	url = $url_ric + path
	uri = URI(url)
	response = Net::HTTP.get_response(uri) # => String
	result = JSON.parse(response.body)
	#@result = result
	#@result = result['urls']
	result['urls'].each do |url|
		#req = Net::HTTP::Post.new(url.path)
		#puts url
		uri = URI(url)
		res = Net::HTTP.post_form(uri, 'q' => 'aaa')
	end

  end

  def dropenrolled
  end

  def addtaken
  end

  def droptaken
  end


end
