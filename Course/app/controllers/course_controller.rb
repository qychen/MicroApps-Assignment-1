class CourseController < ApplicationController


# create course
# URL: /courses/addcourse

=begin

  post '/courses', to: 'Course#create'
  post '/courses/:id/:field/:id', to: 'Course#addToField'
  
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


def addToField 
	course = Course.find(params[:id])[params[:field]]
	if course.nil?
	 	render json {status: 500}
	else
		course.update(params[:field]: course + "," + params[:id2]) 
	 	render json: course
	end 	
end
#Get Actions

def read 
	courses = Course.all
	render json: courses
end

def readFromField 
	 course = Course.find(params[:id])[params[:field]]
	 if course.nil?
		 	render json {status: 500}
	 else
		 	render json: course
	 end 	
end

 #case field 

 #when "title"
 #puts 




# Delete Actions 

def delete
 @courses = Course.delete
 render json: @courses
end

def deleteFromField
 @courses = Course.delete
 render json: @courses
end


# Put Actions

def update 
 @course_update = Course.update
 render json: @courses
end


def updateField 
 @course_update = Course.update
 render json: @courses
end
