class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  $url_ric = "http://45.55.44.135:4000/"
  $url_student = "http://159.203.110.135:3000/"
  $url_course = "http://localhost:5000/"

  #/students/4/coursesEnrolled/2
  def coursesEnrolled
    path = request.path
    studentid = params[:id1]
    courseid = params[:id2]
    #field ||= [].push('student')
    url1 = '{"field": "student", "path": "' + path + '"}'
    url2 = '{"field": "course", "path": "' + 'courses/' + courseid + "/students/" + studentid + '"}'
    (urls ||= []).push(url1)
    urls.push(url2)

    respond_to do |format|
      msg = { :status => "ok", :urls => urls }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end

  #/students/4/coursesTaken/2
  def coursesTaken
    path = request.path
    studentid = params[:id1]
    courseid = params[:id2]
    #field ||= [].push('student')
    url1 = '{"field": "student", "path": "' + path + '"}'   
    (urls ||= []).push(url1)

    respond_to do |format|
      msg = { :status => "ok", :urls => urls }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end

  #/students/4(/last/firstname)
  def changeinfo
    path = request.path
    studentid = params[:id1]
    url1 = '{"field": "student", "path": "' + path + '"}'
    (urls ||= []).push(url1)

    respond_to do |format|
      msg = { :status => "ok", :urls => urls }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end


end
