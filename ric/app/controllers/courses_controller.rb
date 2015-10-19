class CoursesController < ApplicationController

  protect_from_forgery with: :null_session

  $url_ric = "http://45.55.44.135:4000/"
  $url_student = "http://159.203.110.135:3000/"
  $url_course = "http://localhost:5000/"

  #/courses/4/students/2
  def students
    path = request.path
    studentid = params[:id2]
    courseid = params[:id1]
    #field ||= [].push('student')
    url1 = '{"field": "course", "path": "' + path + '"}'
    url2 = '{"field": "student", "path": "' + 'students/' + studentid + "/coursesEnrolled/" + courseid + '"}'
    (urls ||= []).push(url1)
    urls.push(url2)

    respond_to do |format|
      msg = { :status => "ok", :urls => urls }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end

  #/courses/4(/room||title)
  def changeinfo
    path = request.path
    courseid = params[:id1]
    url1 = '{"field": "course", "path": "' + path + '"}'
    (urls ||= []).push(url1)

    respond_to do |format|
      msg = { :status => "ok", :urls => urls }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end

end
