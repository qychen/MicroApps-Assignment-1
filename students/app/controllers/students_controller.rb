class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  FIELDS = [:last_name, :first_name, :courses_taken, :courses_enrolled]
  LIST_FIELDS = [:courses_taken, :courses_enrolled]

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

  def delete
    pupil = Student.find(params[:student_id]) rescue nil
    if pupil
      student = { status: 200, student: pupil }
      pupil.delete
    else
      student = { status: 400 }
    end
    render json: student
  end

  def create_field
    student = Student.find(params[:student_id]) rescue nil
    if student
      field_name = params[:field].to_sym
      if LIST_FIELDS.include? field_name
        pupil = params[:student]
        field = pupil[field_name]
        if field
          course = field
          course = Integer(course) rescue nil
          if course
            courses = student[field_name]
            unless courses
              courses = String.new
            end
            courses = courses.split(',')
            courses << course.to_s
            student[field_name] = courses.uniq.join(',')
            student.save
            field = { status: 200, field_name => student[field_name] }
          else
            field = { status: 400 }
          end
        else
          field = { status: 400 }
        end
      else
        field = { status: 400 }
      end
    else
      field = { status: 400 }
    end
    render json: field
  end

  def read_field
    student = Student.find(params[:student_id]) rescue nil
    if student
      field_name = params[:field].to_sym
      field = student[field_name] rescue nil
      if field
        field = { status: 200, field_name => field }
      else
        field = { status: 400 }
      end
    else
      field = { status: 400 }
    end
    render json: field
  end

  def update_field
    student = Student.find(params[:student_id]) rescue nil
    if student
      field_name = params[:field].to_sym
      if FIELDS.include? field_name
        pupil = params[:student]
        field = pupil[field_name]
        if field
          if LIST_FIELDS.include? field_name
            valid = true
            courses = field.split(',').uniq
            courses.each do |c|
              c.strip!
              course = Integer(c) rescue nil
              unless course
                valid = false
              end
            end
            if valid
              student[field_name] = courses.join(',')
              student.save
              field = { status: 200, field_name => student[field_name] }
            else
              field = { status: 400 }
            end
          else
            student[field_name] = field
            student.save
            field = { status: 200, field_name => student[field_name] }
          end
        else
          field = { status: 400 }
        end
      else
        field = { status: 400 }
      end
    else
      field = { status: 400 }
    end
    render json: field
  end
end
