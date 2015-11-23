require 'net/http'

class CoursesController < ApplicationController
  protect_from_forgery with: :null_session

  $url_ric = "http://45.55.44.135:4000/"
  $url_router = "http://45.55.44.135:3000/"
  $url_student = "http://159.203.110.135:80/"
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
		req = Net::HTTP::Put.new(uri)
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		results.push(res.body)
	end
	#set result!!
	@result = results[0]

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
end