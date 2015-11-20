class CourseController < ApplicationController
  protect_from_forgery with: :null_session

  # create course
  # URL: /courses/addcourse

=begin

  post '/courses', to: 'Course#create'
  

  get '/courses', to: 'Course#read'
  get '/courses/:id', to: 'Course#readOne'
  get '/courses/:id/:field', to: 'Course#readField'



  delete '/courses/:id/:field/:id', to: 'Course#deleteFromField'
  delete '/courses/:id', to: 'Course#delete'

  put '/courses/:id', to: 'Course#update'
  put '/courses/:id/:field', to: 'Course#updateField'

=end

  #Post Actions

  def create 

    course = Course.create
    render json: course

  end

#put
  def update
    course = Course.find(params[:id])
    if course.nil?
      render json: {status: 500}
    else
      students = course[params[:field]]
      course.update(params[:field] => students + "," + params[:id2])
      render json: course
    end 	
  end
  #Get Actions

  def read 
    courses = Course.all
    render json: courses
  end


  def readOne
    course = Course.find(params[:id])
    if course.nil?
      render json: {status: 500}
    else
      render json: course
    end 
  end


  def readFromField 
    course = Course.find(params[:id])[params[:field]]
    if course.nil?
      render json: {status: 500}
    else
      render json: course
    end 	
  end

  #case field 


  # Delete Actions 

  def delete
    course = Course.find(params[:id])
    course = course.delete
    render json: course
  end

  def deleteFromField
    course = Course.find(params[:id])
    if course.nil?
      render json: {status: 500}
    else
      students = course[params[:field]]
      field = students.split(',')
      field.delete(params[:id2])
      course.update(params[:field] => field.join(','))
      render json: course

    end 
  end


  # Put Actions

end
