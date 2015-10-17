class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  $url_ric = "http://45.55.44.135:4000/"
  $url_student = "http://159.203.110.135:3000/"
  $url_course = "http://localhost:5000/"

  #/students/4/addenrolled/2
  def addenrolled
    path = request.path
    studentid = params[:id1]
    courseid = params[:id2]
    url1 = $url_student + path
    url2 = $url_course + "courses/" + courseid + "/addstudent/" + studentid
    (urls ||= []).push(url1)
    urls.push(url2)

    respond_to do |format|
      msg = { :status => "ok", :urls => urls }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end


end
