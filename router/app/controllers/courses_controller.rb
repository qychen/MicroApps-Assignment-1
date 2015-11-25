require 'net/http'
require 'json'

class CoursesController < ApplicationController
  protect_from_forgery with: :null_session

  $url_ric = "http://159.203.107.66:80/"
  #$url_ric = "http://localhost:4000/"
  $url_router = "http://45.55.44.135:80/"
  $url_student = "http://159.203.84.31:80/"
  $url_course = "http://159.203.92.173:80/"

  def changeinfo
	path = request.path
	uri = URI($url_ric + path)
	response = Net::HTTP.get_response(uri) # => String
	ric_result = JSON.parse(response.body)

	#@result ||= []
	results ||= []
	ric_result['urls'].each do |url|
		ric_uri = JSON.parse(url)
		if ric_uri['field'] == "student"
			real_uri = $url_student + ric_uri['path']
		else 
			real_uri = $url_course + ric_uri['path']
		end
		uri = URI(real_uri)
		req = Net::HTTP::Put.new(uri, initheader = {'Content-Type' =>'application/json'})
		req.body = params[:course].to_json
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		results.push(res.body)
	end
	#set result!!
	@result = results[0]
	render json: @result

  end

  def addstudent
	path = request.path
	uri = URI($url_ric + path)
	response = Net::HTTP.get_response(uri) # => String
	ric_result = JSON.parse(response.body)

	#@result ||= []
	results ||= []
	ric_result['urls'].each do |url|
		#req = Net::HTTP::Post.new(url.path)
		ric_uri = JSON.parse(url)
		if ric_uri['field'] == "student"
			real_uri = $url_student + ric_uri['path']
		else 
			real_uri = $url_course + ric_uri['path']
		end
		uri = URI(real_uri)
		#@test = uri
		#res = Net::HTTP.post_form(uri, 'q' => 'aaa')
		req = Net::HTTP::Put.new(uri)
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		results.push(res.body)
		#@result.push(res.body)
		#@result.push(uri)
	end

	#set result!!
	@result = results[0]
	render json: @result
  end

  def dropcourse
	path = request.path
	uri = URI($url_ric + path)
	response = Net::HTTP.get_response(uri) # => String
	ric_result = JSON.parse(response.body)

	#@result ||= []
	results ||= []
	ric_result['urls'].each do |url|
		#req = Net::HTTP::Post.new(url.path)
		ric_uri = JSON.parse(url)
		if ric_uri['field'] == "student"
			real_uri = $url_student + ric_uri['path']
		else 
			real_uri = $url_course + ric_uri['path']
		end
		uri = URI(real_uri)
		#@test = uri
		#res = Net::HTTP.post_form(uri, 'q' => 'aaa')
		req = Net::HTTP::Delete.new(uri)
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		results.push(res.body)
		#@result.push(res.body)
		#@result.push(uri)
	end

	#set result!!
	@result = results[0]
	render json: @result
  end


  def studentlist

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

  	verb = request.request_method
	path = request.path
	puts params[:students]
	uri = URI($url_ric + path)
	req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
	#data = '{"courses"=>"'+params[:courses]+'"}'.to_json
	req.body = params[:course].to_json
	response = Net::HTTP.start(uri.hostname, uri.port) do |http|
	  http.request(req)
	end
	ric_result = JSON.parse(response.body)
	puts "sss"
	puts ric_result
	if ric_result['status'] == 200
		#@result ||= []
		results ||= []
		ric_result['urls'].each do |url|
			ric_uri = JSON.parse(url)
			if ric_uri['field'] == "student"
				real_uri = $url_student + ric_uri['path']
			else 
				real_uri = $url_course + ric_uri['path'] + "students"
			end
			puts "888"
			puts real_uri
			uri = URI(real_uri)
			if verb == "POST"
				req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
			else
				req = Net::HTTP::Delete.new(uri, initheader = {'Content-Type' =>'application/json'})
			end
			if ric_uri['field'] == "student"
				req.body = '{"'+student_field+'":"'+params[:id]+'"}'
			else
				req.body = params[:course].to_json
			end
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end
			results.push(res.body)
		end
		#set result!!
		@result = results[0]
		render json: @result
	else
		res = { status: 400 }
		render json: res
	end

  end

  def overwritestudentlist

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

  	verb = request.request_method
  	puts request.body
	path = request.path
	uri = URI($url_ric + path)
	req = Net::HTTP::Put.new(uri, initheader = {'Content-Type' =>'application/json'})
	#data = '{"courses"=>"'+params[:courses]+'"}'.to_json
	req.body = params[:course].to_json
	response = Net::HTTP.start(uri.hostname, uri.port) do |http|
	  http.request(req)
	end
	ric_result = JSON.parse(response.body)
	if ric_result['status'] == 200
		#@result ||= []
		results ||= []
		ric_result['deleteurls'].each do |url|
			#req = Net::HTTP::Post.new(url.path)
			puts url
			ric_uri = JSON.parse(url)
			if ric_uri['field'] == "student"
				real_uri = $url_student + ric_uri['path']
			else 
				real_uri = $url_course + ric_uri['path'] + "students"
			end
			uri = URI(real_uri)
			if ric_uri['field'] == "student"
				req = Net::HTTP::Delete.new(uri, initheader = {'Content-Type' =>'application/json'})
			else
				req = Net::HTTP::Put.new(uri, initheader = {'Content-Type' =>'application/json'})
			end
			if ric_uri['field'] == "student"
				req.body = '{"'+student_field+'":"'+params[:id]+'"}'
			else
				req.body = params[:course].to_json
			end
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end
			results.push(res.body)
		end
		ric_result['posturls'].each do |url|
			ric_uri = JSON.parse(url)
			real_uri = $url_student + ric_uri['path']
			uri = URI(real_uri)
			puts "999"
			puts real_uri
			req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
			req.body = '{"'+student_field+'":"'+params[:id]+'"}'
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end
			results.push(res.body)
		end
		#set result!!
		@result = results[0]
		render json: @result
	else
		res = { status: 400 }
		render json: res
	end
  end

  def create
  	puts "etete"
	path = request.path
	uri = URI($url_ric + path)
	req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
	req.body = params[:course].to_json
	response = Net::HTTP.start(uri.hostname, uri.port) do |http|
	  http.request(req)
	end
	ric_result = JSON.parse(response.body)
	puts "sssddd"
	puts ric_result
	if ric_result['status'] == 200
		results ||= []
		# create course
		url = ric_result['urls'][0]
		ric_uri = JSON.parse(url)
		real_uri = $url_course + ric_uri['path']
		uri = URI(real_uri)
		req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
		req.body = params[:course].to_json
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			http.request(req)
		end
		results.push(res.body)
		course_result = JSON.parse(res.body)['new_course']

		ric_result['urls'][1,ric_result['urls'].length].each do |url|
			ric_uri = JSON.parse(url)
			if ric_uri['field'] == "student"
				real_uri = $url_student + ric_uri['path']
			else 
				real_uri = $url_course + ric_uri['path']
			end
			uri = URI(real_uri)
			req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
			if ric_uri['field'] == "course"
				req.body = params[:course].to_json
			else
				#get new course info
				puts "0000000"
				puts course_result
				if course_result['current'] == true
					req.body = '{"courses_enrolled":"'+course_result['id'].to_s+'"}'
				else
					req.body = '{"courses_taken":"'+course_result['id'].to_s+'"}'
				end
			end
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end
			results.push(res.body)
		end
		#set result!!
		@result = results[0]
		render json: @result
	else
		res = { status: 400 }
		render json: res
	end

  end

  def delete
	path = request.path
	uri = URI($url_ric + path)
	req = Net::HTTP::Delete.new(uri, initheader = {'Content-Type' =>'application/json'})
	req.body = params[:student].to_json
	response = Net::HTTP.start(uri.hostname, uri.port) do |http|
	  http.request(req)
	end
	ric_result = JSON.parse(response.body)
	puts "sssddd"
	puts ric_result
	if ric_result['status'] == 200

		results ||= []
		# create course
		url = ric_result['urls'][0]
		ric_uri = JSON.parse(url)
		real_uri = $url_course + ric_uri['path']
		uri = URI(real_uri)
		req = Net::HTTP::Delete.new(uri, initheader = {'Content-Type' =>'application/json'})
		req.body = params[:course].to_json
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			http.request(req)
		end
		results.push(res.body)
		course_result = JSON.parse(res.body)


		ric_result['urls'][1,ric_result['urls'].length].each do |url|
			ric_uri = JSON.parse(url)
			if ric_uri['field'] == "student"
				real_uri = $url_student + ric_uri['path']
			else 
				real_uri = $url_course + ric_uri['path'] + "/students"
			end
			uri = URI(real_uri)
			req = Net::HTTP::Delete.new(uri, initheader = {'Content-Type' =>'application/json'})
			if ric_uri['field'] == "course"
				req.body = params[:course].to_json
			else
				#get new course info
				if course_result['current'] == true
					req.body = '{"courses_enrolled":"'+course_result['id'].to_s+'"}'
				else
					req.body = '{"courses_taken":"'+course_result['id'].to_s+'"}'
				end
			end
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end
			results.push(res.body)
		end
		#set result!!
		@result = results[0]
		render json: @result
	else
		res = { status: 400 }
		render json: res
	end

  end

  def doget
	path = request.path
	uri = URI($url_course + path)
	response = Net::HTTP.get_response(uri) # => String
	@result = response.body
	render json: @result
  end

  def current
	path = request.path

    courses_uri = URI($url_course + "/courses/"+params[:id])
    response = Net::HTTP.get_response(courses_uri) # => String
    course_result = JSON.parse(response.body)['course']
    if course_result['current'] == true
    	field_old = 'courses_enrolled'
    	field_new = 'courses_taken'
    else
    	field_old = 'courses_taken'
    	field_new = 'courses_enrolled'
    end

    puts course_result

	if JSON.parse(response.body)['status'] == 200
		puts "333333333"
		students_id =course_result['students'].split(",") rescue []
		students_id.each do |studentid|

			real_uri = $url_student +  'students/' + studentid + '/' + field_old
			puts "77777"
			puts real_uri
			uri = URI(real_uri)
			req = Net::HTTP::Delete.new(uri, initheader = {'Content-Type' =>'application/json'})
			req.body = '{"'+field_old+'":"'+course_result['id'].to_s+'"}'
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end

			real_uri = $url_student + 'students/' + studentid + '/' + field_new
			puts "9988888"
			puts real_uri
			uri = URI(real_uri)
			req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
			req.body = '{"'+field_new+'":"'+course_result['id'].to_s+'"}'
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end

		end
		courses_uri = $url_course + 'courses/'+params[:id] + '/current'
		puts "666"
		puts courses_uri
		uri = URI(courses_uri)
		req = Net::HTTP::Put.new(uri, initheader = {'Content-Type' =>'application/json'})
		req.body = params[:course].to_json
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		render json: res.body

	else
		res = { status: 400 }
		render json: res
	end


  end

end






