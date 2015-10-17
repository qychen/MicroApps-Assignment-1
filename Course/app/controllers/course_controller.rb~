class CourseController < ApplicationController


# create course
# URL: /courses/addcourse

def create 
 @course_add = Course.new(params[:courses], params[:addcourse])
   if @course_add.save 
      @result = 'success'
      redirect_to @course_add
   end
 end

end

# create student
# URL: /courses/id/addstudent/id

def create 
 @student_add = Course.new(params[:courses],params[:id], params[:addstudent],params[:id])
   if @student_add.save 
      @result = 'success'
      redirect_to @student_add
   end
 end

end

# read courses
# URL: /courses

def read 
 @courses = Course.all(params[:courses])
   if 
      Course.all.to_json
      respond_to do |format|
      format.json{render json:@result}
      redirect_to @course
   end
 end

# read one course
# URL: /courses/id

def read 
 @course = Course.find(params[:courses], params[:id])
   if 
      Course.to_json
      respond_to do |format|
      format.json{render json:@result}
      redirect_to @course
   end
 end

# update course info
# URL: /courses/id/update

def update 
 @course_update = Course.find(params[:courses],params[:id], params[:update])
   if @course_update.update(params[:course_update]) 
      @course_update.save
      Course.to_json
      respond_to do |format|
      format.json{render json:@result}
      redirect_to @course_update
   else @result = 'update fail'
   end
 end


# delete course
# URL: /courses/id/delete

def delete 
 @course_delete = Course.find(params[:courses],params[:id],params[:delete])
   if @course_delete.delete
      @result = 'course successfully deleted' 
      redirect_to @course_delete
   end
 end

# delete student
# URL: /courses/id/student/id/delete

def delete 
 @student_delete = Course.update(params[:courses],params[:id], params[:student], params[:id],params[:delete])
   if @student_delete.delete
      @result = 'student successfully deleted' 
      redirect_to @course_delete
   end
 end
