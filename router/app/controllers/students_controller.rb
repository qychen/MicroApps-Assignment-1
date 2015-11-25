require 'net/http'
require 'json'

class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  $url_ric = "http://159.203.107.66:80/"
  #$url_ric = "http://localhost:4000/"
  $url_router = "http://45.55.44.135:80/"
  $url_student = "http://159.203.84.31:80/"
  $url_course = "http://159.203.92.173:80/"
=begin
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
=end

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
		req = Net::HTTP::Put.new(uri)
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		results.push(res.body)
	end
	#set result!!
	@result = results[0]

  end

  def addcourse
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
  end

  def doget
	path = request.path
	uri = URI($url_student + path)
	response = Net::HTTP.get_response(uri) # => String
	@result = response.body

  end

  def create
  	puts "etete"
  	puts params[:student]['uni']
	path = request.path
	uri = URI($url_ric + path)
	req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
	req.body = params[:student].to_json
	response = Net::HTTP.start(uri.hostname, uri.port) do |http|
	  http.request(req)
	end
	ric_result = JSON.parse(response.body)
	puts "sssddd"
	puts ric_result
	if ric_result['status'] == 200
		results ||= []
		ric_result['urls'].each do |url|
			ric_uri = JSON.parse(url)
			if ric_uri['field'] == "student"
				real_uri = $url_student + ric_uri['path']
			else 
				real_uri = $url_course + ric_uri['path']
			end
			uri = URI(real_uri)
			req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
			if ric_uri['field'] == "student"
				req.body = params[:student].to_json
			else
				req.body = '{"students":"'+params[:student]['uni']+'"}'
			end
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end
			results.push(res.body)
		end
		#set result!!
		@result = results[0]
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
		ric_result['urls'].each do |url|
			ric_uri = JSON.parse(url)
			if ric_uri['field'] == "student"
				real_uri = $url_student + ric_uri['path']
			else 
				real_uri = $url_course + ric_uri['path']
			end
			uri = URI(real_uri)
			req = Net::HTTP::Delete.new(uri, initheader = {'Content-Type' =>'application/json'})
			if ric_uri['field'] == "student"
			else
				req.body = '{"students":"'+params[:id]+'"}'
			end
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end
			results.push(res.body)
		end
		#set result!!
		@result = results[0]
	else
		res = { status: 400 }
		render json: res
	end
  end
  
  def courselist
  	verb = request.request_method
  	puts request.body
	#path = request.path.split("/")[-1]
	#uri = URI($url_ric + "/students/"+params[:id]+"/courselist")
	path = request.path
	puts params[:courses]
	uri = URI($url_ric + path)
	req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
	#data = '{"courses"=>"'+params[:courses]+'"}'.to_json
	req.body = params[:student].to_json
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
			#req = Net::HTTP::Post.new(url.path)
			ric_uri = JSON.parse(url)
			if ric_uri['field'] == "student"
				real_uri = $url_student + ric_uri['path'] + params[:field]
			else 
				real_uri = $url_course + ric_uri['path']
			end
			uri = URI(real_uri)
			#@test = uri
			#res = Net::HTTP.post_form(uri, 'q' => 'aaa')
			if verb == "POST"
				req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
			else
				req = Net::HTTP::Delete.new(uri, initheader = {'Content-Type' =>'application/json'})
			end
			if ric_uri['field'] == "student"
				req.body = params[:student].to_json
			else
				req.body = '{"students":"'+params[:id]+'"}'
			end
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end
			results.push(res.body)
			#@result.push(res.body)
			#@result.push(uri)
		end
		#set result!!
		@result = results[0]
	else
		res = { status: 400 }
		render json: res
	end

  end

  def overwritecourselist
  	verb = request.request_method
  	puts request.body
	path = request.path
	puts params[:courses]
	uri = URI($url_ric + path)
	req = Net::HTTP::Put.new(uri, initheader = {'Content-Type' =>'application/json'})
	#data = '{"courses"=>"'+params[:courses]+'"}'.to_json
	req.body = params[:student].to_json
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
				real_uri = $url_course + ric_uri['path']
			end
			uri = URI(real_uri)
			if ric_uri['field'] == "student"
				req = Net::HTTP::Put.new(uri, initheader = {'Content-Type' =>'application/json'})
			else
				req = Net::HTTP::Delete.new(uri, initheader = {'Content-Type' =>'application/json'})
			end
			if ric_uri['field'] == "student"
				req.body = params[:student].to_json
			else
				req.body = '{"students":"'+params[:id]+'"}'
			end
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end
			results.push(res.body)
		end
		ric_result['posturls'].each do |url|
			ric_uri = JSON.parse(url)
			real_uri = $url_course + ric_uri['path']
			uri = URI(real_uri)
			req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
			req.body = '{"students":"'+params[:id]+'"}'
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  	http.request(req)
			end
			results.push(res.body)
		end
		#set result!!
		@result = results[0]
	else
		res = { status: 400 }
		render json: res
	end
  end


end
