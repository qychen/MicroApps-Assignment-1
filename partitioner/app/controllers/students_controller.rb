require 'net/http'
require 'uri'
require 'json'

class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  PARTITIONS = ['http://159.203.110.135:3001', 'http://159.203.110.135:3002', 'http://159.203.110.135:3003']

  def index
    students = Array.new
    PARTITIONS.each do |p|
      uri = URI.parse("#{p}/students?#{request.query_string}")
      response = Net::HTTP.get_response(uri)
      json = JSON.parse(response.body)
      if json['status'] == 200
        students += json['students']
      end
    end
    render json: { status: 200, students: students }
  end

  def read
    name = params[:student_id][/[[:alpha:]]+/]
    if name
      last_initial = name[-1]
      if last_initial
        p = partition(last_initial)
        uri = URI.parse("#{p}/students/#{params[:student_id]}/#{params[:path]}")
        response = Net::HTTP.get_response(uri)
        student = JSON.parse(response.body)
      else
        student = { status: 400 }
      end
    else
      student = { status: 400 }
    end
    render json: student
  end

  def create
    uni = params[:student_id]
    name = params[:student_id][/[[:alpha:]]+/] rescue nil
    unless name
      name = params[:student][:uni][/[[:alpha:]]+/] rescue nil
      uni = params[:student][:uni]
    end
    if name
      last_initial = name[-1]
      if last_initial
        p = partition(last_initial)
        uri = URI.parse("#{p}/students/#{params[:student_id]}/#{params[:path]}")
        request = Net::HTTP::Post.new(uri, initheader = {'Content-Type' => 'application/json'})
        request.body = params[:student].to_json
        response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(request)
        end
        student = JSON.parse(response.body)
      else
        student = { status: 400 }
      end
    else
      student = { status: 400 }
    end
    render json: student
  end

  def update
    uni = params[:student_id]
    name = params[:student_id][/[[:alpha:]]+/] rescue nil
    unless name
      name = params[:student][:uni][/[[:alpha:]]+/] rescue nil
      uni = params[:student][:uni]
    end
    if name
      last_initial = name[-1]
      if last_initial
        p = partition(last_initial)
        uri = URI.parse("#{p}/students/#{params[:student_id]}/#{params[:path]}")
        request = Net::HTTP::Put.new(uri, initheader = {'Content-Type' => 'application/json'})
        request.body = params[:student].to_json
        response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(request)
        end
        student = JSON.parse(response.body)
      else
        student = { status: 400 }
      end
    else
      student = { status: 400 }
    end
    render json: student
  end

  def delete
    uni = params[:student_id]
    name = params[:student_id][/[[:alpha:]]+/] rescue nil
    unless name
      name = params[:student][:uni][/[[:alpha:]]+/] rescue nil
      uni = params[:student][:uni]
    end
    if name
      last_initial = name[-1]
      if last_initial
        p = partition(last_initial)
        uri = URI.parse("#{p}/students/#{params[:student_id]}/#{params[:path]}")
        request = Net::HTTP::Delete.new(uri, initheader = {'Content-Type' => 'application/json'})
        request.body = params[:student].to_json
        response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(request)
        end
        student = JSON.parse(response.body)
      else
        student = { status: 400 }
      end
    else
      student = { status: 400 }
    end
    render json: student
  end

  def partition(last_initial)
    if ('a'..'i').include? last_initial
      return PARTITIONS[0]
    elsif ('j'..'r').include? last_initial
      return PARTITIONS[1]
    else
      return PARTITIONS[2]
    end
  end
end
