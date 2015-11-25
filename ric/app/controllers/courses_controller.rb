require 'net/http'

class CoursesController < ApplicationController

  protect_from_forgery with: :null_session

  $url_ric = "http://159.203.107.66:80/"
  #$url_ric = "http://localhost:4000/"
  $url_router = "http://45.55.44.135:80/"
  $url_student = "http://159.203.84.31:80/"
  $url_course = "http://159.203.92.173:80/"

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



  def studentlist
    path = request.path
    courseid = params[:id]
    url1 = '{"field": "course", "path": "' + 'courses/' + courseid + '/"}'
    (urls ||= []).push(url1)
    flag = 1

    uri = URI($url_course + "/courses/"+courseid)
    response = Net::HTTP.get_response(uri) # => String
    course_result = JSON.parse(response.body)['course']

    list = params[:students].split(",")
    list.each do |studentid|
      uri = URI($url_student + "/students/"+studentid)
      response = Net::HTTP.get_response(uri) # => String
      result = JSON.parse(response.body)
      puts "asasasa"
      puts result['status'].inspect
      if result['status'] == 200
        puts "yeaaaaaa"
        if course_result['current'] == true
          url2 = '{"field": "student", "path": "' + 'students/' + studentid + "/courses_enrolled" + '"}'
        else
          url2 = '{"field": "student", "path": "' + 'students/' + studentid + "/courses_taken" + '"}'
        end
        urls.push(url2)

      else  
        puts "noooo"
        flag = 0
        break
      end

    end
    if flag == 0
      respond_to do |format|
        msg = { :status => 400}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    else
      respond_to do |format|
        msg = { :status => 200, :urls => urls }
        format.json  { render :json => msg } # don't do msg.to_json
      end
    end
  end


  def overwritestudentlist
    path = request.path
    courseid = params[:id]
    url1 = '{"field": "course", "path": "' + 'courses/' + courseid + '/"}'
    flag = 1

    (deleteurls ||= []).push(url1)
    posturls ||= []

    uri = URI($url_course + "/courses/"+courseid)
    response = Net::HTTP.get_response(uri) # => String
    course_result = JSON.parse(response.body)['course']
    if course_result['current'] == true
      student_field = "courses_enrolled"
    else
      student_field = "courses_taken"
    end

    list = params[:students].split(",")
    list.each do |studentid|
      uri = URI($url_student + "/students/"+studentid)
      response = Net::HTTP.get_response(uri) # => String
      result = JSON.parse(response.body)
      if result['status'] == 200
        if course_result['current'] == true
          url2 = '{"field": "student", "path": "' + 'students/' + studentid + "/courses_enrolled" + '"}'
        else
          url2 = '{"field": "student", "path": "' + 'students/' + studentid + "/courses_taken" + '"}'
        end
        posturls.push(url2)

      else  
        flag = 0
        break
      end

    end
    if flag == 0
      respond_to do |format|
        msg = { :status => 400}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    else
      #get delete student list
      uri = URI($url_course + "/courses/"+courseid+"/students")
      response = Net::HTTP.get_response(uri) # => String
      result = JSON.parse(response.body)['field'].split(",")
      result.each do |studentid|
        url = '{"field": "student", "path": "' + 'students/' + studentid + "/" + student_field + '"}'
        deleteurls.push(url)
      end

      respond_to do |format|
        msg = { :status => 200, :posturls => posturls, :deleteurls => deleteurls }
        format.json  { render :json => msg } # don't do msg.to_json
      end
    end
  end

  def create
    path = request.path
    students_id = params[:course]['students']
    if params[:course]['current'] == true
      student_field = "courses_enrolled"
    else
      student_field = "courses_taken"
    end
    url1 = '{"field": "course", "path": "' + path + '/"}'
    (urls ||= []).push(url1)
    flag = 1
    if students_id
      puts "///sss"
      students_id = students_id.split(",")
      students_id.each do |studentid|
        uri = URI($url_student + "/students/"+studentid)
        response = Net::HTTP.get_response(uri) # => String
        result = JSON.parse(response.body)
        if result['status'] == 200
          url2 = '{"field": "student", "path": "' + 'students/' + studentid + '/' +student_field + '"}'
          urls.push(url2)
        else  
          flag = 0
          break
        end
      end
    end

    if flag == 0
      respond_to do |format|
        msg = { :status => 400}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    else
      respond_to do |format|
        msg = { :status => 200, :urls => urls }
        format.json  { render :json => msg } # don't do msg.to_json
      end
    end

  end

  def delete
    path = request.path

    uri = URI($url_course + "/courses/"+params[:id])
    response = Net::HTTP.get_response(uri) # => String
    result = JSON.parse(response.body)
    if result['status'] == 200
      students_id = result['course']['students']  
      if result['course']['current'] == true
        student_field = "courses_enrolled"
      else
        student_field = "courses_taken"
      end
    else
      respond_to do |format|
        msg = { :status => 400}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    end

    url1 = '{"field": "course", "path": "' + path + '/"}'
    (urls ||= []).push(url1)
    flag = 1
    if students_id
      students_id = students_id.split(",")
      students_id.each do |studentid|
        url2 = '{"field": "student", "path": "' + 'students/' + studentid + '/' + student_field + '"}'
        urls.push(url2)
      end
    end

    if flag == 0
      respond_to do |format|
        msg = { :status => 400}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    else
      respond_to do |format|
        msg = { :status => 200, :urls => urls }
        format.json  { render :json => msg } # don't do msg.to_json
      end
    end

  end

end
