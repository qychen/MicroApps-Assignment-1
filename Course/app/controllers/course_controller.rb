class CourseController < ApplicationController


# create course
# URL: /courses/add

def create 
 @course_add = Course.new(params[:courses], params[:add])
   if @course_add.save 
      @result = 'success'
      redirect_to @course_add
   end
 end

end
