require 'net/http'
require 'uri'

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
