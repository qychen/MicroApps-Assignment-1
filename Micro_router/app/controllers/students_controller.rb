class StudentsController < ApplicationController
  $url_ric = "http://localhost:6000/"
  $url_student = "http://localhost:4000/"
  $url_course = "http://localhost:6000/"

  #return student info back; via :get
  def info
    id1 = params[:id1]
    url = $url_student + id1
    @result = url
  end

  def ric
  	flag = params[:flag]
  	if flag
  		redirect_to(:action)
  	else
  		url = $url_ric + "aaa"
  		@result = url
  	end
  end

  def changelastname
    url = $url_student + params[:id1] + "/changelastname"
    @result = url 
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
