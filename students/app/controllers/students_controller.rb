class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  FIELDS = [:last_name, :first_name, :courses_taken, :courses_enrolled]

  def index
    students = { status: 200, students: Student.all }
    render json: students
  end

  def create
    student = Student.new
    pupil = params[:student]
    FIELDS.each do |f|
      student[f] = pupil[f]
    end
    student.save
    student = { status: 200, student: student }
    render json: student
  end

  def read
    student = Student.find(params[:student_id]) rescue nil
    if student
      student = { status: 200, student: student }
    else
      student = { status: 400 }
    end
    render json: student
  end

  def update
    student = Student.find(params[:student_id]) rescue nil
    if student
      pupil = params[:student]
      FIELDS.each do |f|
        student[f] = pupil[f]
      end
      student.save
      student = { status: 200, student: student }
    else
      student = { status: 400 }
    end
    render json: student
  end
end
