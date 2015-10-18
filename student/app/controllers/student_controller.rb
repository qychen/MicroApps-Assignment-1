class StudentController < ApplicationController
	protect_from_forgery with: :null_session
	layout false
  #action we are asking this view to perform
  def index
  end

  	def show
		students = User.all
		render json: @students
	end

	def add_student
		#@student = Student.create
	end

	def add_course
		id1 = params['id1']
		id2 = params['id2']
		student = User.find(id1)
		courses = student[:courses_enrolled]
		student.update(courses_enrolled: courses + "," + id2)
		render json: student
	end

	def drop_course
		@id = params['course_name']
	end

	def add_takenCourse
		@id = params['course_name']
	end

	def drop_takenCourse
		@id = params['course_name']
	end

	def edit_lastname
		@id = params['last_name']
	end

	def edit_firstname
		@id = params['first_name']
	end

	def remove_student

	end

	def update_student
	end

	def create_student
	end
end
