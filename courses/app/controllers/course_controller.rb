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
	if new_course[:current].nil?
		new_course[:current] = false
		new_course.save
	end
    render json: { status:200, new_course: new_course}

  end

  def createInField

  	field = Course.find(params[:id]) rescue nil
    field_name = params[:field].to_sym
    field2 = field[field_name]
    if field2.nil? 
      field2 = String.new
    end

  	if LIST_FIELDS.include? field_name
  		new_field = params[:course]
      new_field = new_field[params[:field]]
      new_field = new_field.split(",")
      split_field = field2.split(",")
      split_field = split_field + new_field # add element(s) to array
  		field[field_name] = split_field.uniq.join(',')
  		field.save
      return render json: {status:200, field:field}
  	
    end
     
  		  
 end

#put
  def update
    course = Course.find(params[:id]) rescue nil
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
    course = Course.find(params[:id]) rescue nil
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
    query = String.new
    arguments = Array.new
    fields = 0
    FIELDS.each do |f|
      if params[f]
        fields += 1
      end
      if params[f] && !(LIST_FIELDS.include? f)
        unless query.empty?
          query << " AND #{f} = ?"
        else 
          query << "#{f} = ?"
        end
        arguments << params[f]
      end
    end
    if fields == 0 
      courses = {status:200, courses: Course.all}
    else 
      courses = Course.where(query,*arguments)
      failure = false
      courses = courses.select{ |course|
        valid = true
        LIST_FIELDS.each do |field|
          students = course[field].split(',').uniq rescue Array.new
          if params[field]
            fields = params[field].split(',').uniq
            unless (fields - students).empty?
              valid = false
              break
            end
        end
    end
    valid
    }
    courses = {status:200, courses: courses}
  end
    render json: courses
  end





  def readOne
    course = Course.find(params[:id]) rescue nil
    if course.nil?
      render json: {status: 400}
    else
      render json: {status: 200, course: course}
    end 
  end


  def readFromField 
    field = Course.find(params[:id]) rescue nil
    field = field[params[:field]] 

    if field.nil?
      render json: {status: 400}
    else
      render json: {status:200, field: field} # symbol field is rocketed to field value
    end 	
  end

  #case field 


  # Delete Actions 

  def delete
    course = Course.find(params[:id])rescue nil
    if course.nil? 
      render json: {status:400}
    else
    course = course.delete
    course.save
    render json: course
  end

  end

  def deleteFromField
    course = Course.find(params[:id]) rescue nil
    if course.nil?
      render json: {status: 400}
    else 
    	field_name = params[:field].to_sym
    
 		
      	if LIST_FIELDS.include? field_name
			       removable_content = params[:course] #retrieve json object
             removable_content2 = removable_content[params[:field]] #access the field specified
			     
             if removable_content2 
		  		      field_content = course[field_name]
					unless field_content
						field_content = String.new
					end
		  		      field_content = field_content.split(',')
                removable_content2 = removable_content2.split(',')
                removable_content2.each do |f|
                field_content.delete(f)
                end
                field_content = field_content.uniq.join(',')
                course[field_name] = field_content 
                course.save
                return render json: {status:200, field_name => field_content }
                
             end
        end
    end
  end




end
