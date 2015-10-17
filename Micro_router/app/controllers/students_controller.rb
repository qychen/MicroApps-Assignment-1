require 'faraday'
require 'net/http'

class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  $url_ric = "http://localhost:6000/"
  $url_student = "http://159.203.110.135:3000/"
  $url_course = "http://localhost:5000/"

  #return student info back; via :get
  def info
    id1 = params[:id1]
    url = $url_student + "demo/info/" + id1

    uri = URI.parse(url)
	#res = Net::HTTP.post_form(uri, 'q' => 'ruby', 'max' => '50')
	res = Net::HTTP.post_form(uri, 'id' => id1)
	@result = res.body

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
  end

  def dropenrolled
  end

  def addtaken
  end

  def droptaken
  end


end
