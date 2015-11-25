require 'net/http'

class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  $url_ric = "http://159.203.107.66:80/"
  $url_router = "http://45.55.44.135:80/"
  $url_student = "http://159.203.110.135:3001/"
  $url_course = "http://159.203.92.173:80/"
  #$url_course = "http://159.203.110.135:80/"

  def courselist
    path = request.path
    studentid = params[:id]
    url1 = '{"field": "student", "path": "' + 'students/' + studentid + '/"}'
    (urls ||= []).push(url1)
    flag = 1

    list = params[params[:field]].split(",")
    list.each do |courseid|
      uri = URI($url_course + "/courses/"+courseid)
      response = Net::HTTP.get_response(uri) # => String
      result = JSON.parse(response.body)
      puts "asasasa"
      puts result['status'].inspect
      if result['status'] == 200
        puts "yeaaaaaa"
        url2 = '{"field": "course", "path": "' + 'courses/' + courseid + "/students" + '"}'
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


  def overwritecourselist
    path = request.path
    studentid = params[:id]
    url1 = '{"field": "student", "path": "' + 'students/' + studentid + '/' + params[:field] +'"}'
    (deleteurls ||= []).push(url1)
    posturls ||= []
    flag = 1
    list = params[params[:field]].split(",")
    list.each do |courseid|
      uri = URI($url_course + "/courses/"+courseid)
      response = Net::HTTP.get_response(uri) # => String
      result = JSON.parse(response.body)
      if result['status'] == 200
        url2 = '{"field": "course", "path": "' + 'courses/' + courseid + "/students" + '"}'
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
      #get delete course list
      uri = URI($url_student + "/students/"+studentid+"/"+params[:field])
      response = Net::HTTP.get_response(uri) # => String
      result = JSON.parse(response.body)[params[:field]].split(",")
      result.each do |courseid|
        url = '{"field": "course", "path": "' + 'courses/' + courseid + "/students" + '"}'
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
    course_enroll = params[:student]['courses_enrolled']
    course_taken = params[:student]['courses_taken']
    url1 = '{"field": "student", "path": "' + path + '/"}'
    (urls ||= []).push(url1)
    flag = 1
    if course_enroll
      puts "!!!???"
      course_enroll = course_enroll.split(",")
      course_enroll.each do |courseid|
        uri = URI($url_course + "/courses/"+courseid)
        response = Net::HTTP.get_response(uri) # => String
        result = JSON.parse(response.body)
        if result['status'] == 200
          url2 = '{"field": "course", "path": "' + 'courses/' + courseid + "/students" + '"}'
          urls.push(url2)
        else  
          flag = 0
          break
        end
      end
    end
    if course_taken
      puts "///sss"
      course_taken = course_taken.split(",")
      course_taken.each do |courseid|
        uri = URI($url_course + "/courses/"+courseid)
        response = Net::HTTP.get_response(uri) # => String
        result = JSON.parse(response.body)
        if result['status'] == 200
          url2 = '{"field": "course", "path": "' + 'courses/' + courseid + "/students" + '"}'
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

    uri = URI($url_student + "/students/"+params[:id]+"/courses_enrolled")
    response = Net::HTTP.get_response(uri) # => String
    result = JSON.parse(response.body)
    if result['status'] == 200
      course_enroll = result['courses_enrolled']  
    else 
      course_enroll = nil
    end
    uri = URI($url_student + "/students/"+params[:id]+"/courses_taken")
    response = Net::HTTP.get_response(uri) # => String
    result = JSON.parse(response.body)
    if result['status'] == 200
      course_taken = result['courses_taken']  
    else 
      course_taken = nil
    end


    url1 = '{"field": "student", "path": "' + path + '/"}'
    (urls ||= []).push(url1)
    flag = 1
    if course_enroll
      course_enroll = course_enroll.split(",")
      course_enroll.each do |courseid|
        url2 = '{"field": "course", "path": "' + 'courses/' + courseid + "/students" + '"}'
        urls.push(url2)
      end
    end
    if course_taken
      course_enroll = course_taken.split(",")
      course_enroll.each do |courseid|
        url2 = '{"field": "course", "path": "' + 'courses/' + courseid + "/students" + '"}'
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
