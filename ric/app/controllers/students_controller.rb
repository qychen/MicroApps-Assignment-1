require 'net/http'

class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  $url_ric = "http://159.203.107.66:80/"
  $url_router = "http://45.55.44.135:80/"
  $url_student = "http://159.203.110.135:80/"
  $url_course = "http://159.203.92.173:3000/"

  def courselist
    path = request.path
    studentid = params[:id]
    url1 = '{"field": "student", "path": "' + 'students/' + studentid + '/"}'
    (urls ||= []).push(url1)
    flag = 1
    list = params[:courses].split(",")
    list.each do |courseid|
      uri = URI($url_course + "/courses/"+courseid)
      response = Net::HTTP.get_response(uri) # => String
      result = JSON.parse(response.body)
      if result['status'] == "200"
        url2 = '{"field": "course", "path": "' + 'courses/' + courseid + "/students" + '"}'
        urls.push(url2)

      else  
        flag = 0
        break
      end

    end
    if flag == "0"
      respond_to do |format|
        msg = { :status => "400"}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    else
      respond_to do |format|
        msg = { :status => "200", :urls => urls }
        format.json  { render :json => msg } # don't do msg.to_json
      end
    end
  end


  def overwritecourselist
    path = request.path
    studentid = params[:id]
    url1 = '{"field": "student", "path": "' + 'students/' + studentid + '/"}'
    (posturls ||= []).push(url1)
    flag = 1
    list = params[:courses].split(",")
    list.each do |courseid|
      uri = URI($url_course + "/courses/"+courseid)
      response = Net::HTTP.get_response(uri) # => String
      result = JSON.parse(response.body)
      if result['status'] == "200"
        url2 = '{"field": "course", "path": "' + 'courses/' + courseid + "/students" + '"}'
        posturls.push(url2)

      else  
        flag = 0
        break
      end

    end
    if flag == "0"
      respond_to do |format|
        msg = { :status => "400"}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    else
      #get delete course list
      uri = URI($url_student + "/students/"+studentid+"/"+params[:field])
      response = Net::HTTP.get_response(uri) # => String
      result = JSON.parse(response.body)[params[:field]].split(",")
      deleteurls ||= []
      result.each do |courseid|
        url = '{"field": "course", "path": "' + 'courses/' + courseid + "/students" + '"}'
        deleteurls.push(url)
      end

      respond_to do |format|
        msg = { :status => "200", :posturls => posturls, :deleteurls => deleteurls }
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
