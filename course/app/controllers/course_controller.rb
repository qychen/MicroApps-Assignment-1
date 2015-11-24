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

FIELDS = [:title, :room, :current, :students]
LIST_FIELDS = [:students]

  #Post Actions

  def create 

    new_course = Course.new
    course_info = params[:course]
    
    FIELDS.each do |f|
   	new_course[f] = course_info[f]
    new_course.save
	end
    render json: { status:200, new_course:new_course}

  end

  def createInField

  	field = Course.find(params[:id])[params[:field]]
  	field_name = params[:field].to_sym

  	if LIST_FIELDS.include? field_name
  		
  		new_field = params[:id2]
  		split_field = field.split(",")
  		split_field << new_field # add element to array
  		field = split_field.join(',')
  		return render json: {status:200, field:field}
  		field.save
  	end
  		  
 end

#put
  def update
    course = Course.find(params[:id])
    if course.nil?
      render json: {status: 400}
    else
      course_info =  params[:course]
      
      FIELDS.each do |f|
      	course[f] = course_info[f]
      	course.save
      end
      render json: {status: 200, course: course}

    end 	
  end



  def updateField
    course = Course.find(params[:id])
    if course.nil?
      render json: {status: 400}
    else
      field_name = params[:field].to_sym
      
      if FIELDS.include? field_name
      	course_info = params[:course]
      	field_content = course_info[field_name]
      	
      	if field_content
      		course[field_name] = field_content
     		course.save
        end
      end
    end
    render json: {status:200, course:course}	
  end
  #Get Actions



  def read 
    courses = Course.all
    render json: {status:200, courses: courses}



  end



  def readOne
    course = Course.find(params[:id])
    if course.nil?
      render json: {status: 500}
    else
      render json: {status: 200, course: course}
    end 
  end


  def readFromField 
    field = Course.find(params[:id])[params[:field]]

    if field.nil?
      render json: {status: 500}
    else
      render json: {status:200, field: field} # symbol field is rocketed to field value
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
    	field_name = params[:field].to_sym
 		
      	if LIST_FIELDS.include? field_name
			removable_content = params[:id2]
			if removable_content
		  		field_content = course[field_name]
		  		if field_content
		  		field_content = field_content.split(',')
				new_field_content = field_content.delete(removable_content)
				end
			else 
				render json: {status: 400}

      	    end
      	end
  	  
  	  render json: {status:200, field_name => field_content }

  	end	  
  end

end
