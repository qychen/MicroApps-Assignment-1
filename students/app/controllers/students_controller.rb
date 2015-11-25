class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  FIELDS = [:last_name, :first_name, :courses_taken, :courses_enrolled]
  LIST_FIELDS = [:courses_taken, :courses_enrolled]

  def index
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
      students = { status: 200, students: Student.all }
    else
      students = Student.where(query, *arguments)
      failure = false
      students = students.select { |student|
        valid = true
        LIST_FIELDS.each do |field|
          courses = student[field].split(',').uniq rescue Array.new
          if params[field]
            fields = params[field].split(',').uniq
            unless (fields - courses).empty?
              valid = false
              break
            end
          end
        end
        valid
      }
      students = { status: 200, students: students }
    end
    render json: students
  end

  def create
    student = Student.new
    pupil = params[:student]
    if pupil[Student.primary_key]
      unless pupil[Student.primary_key].empty?
        padawan = Student.find(pupil[Student.primary_key]) rescue nil
        unless padawan
          student[Student.primary_key] = pupil[Student.primary_key]
          FIELDS.each do |f|
            student[f] = pupil[f]
          end
          student.save
          student = { status: 200, student: student }
        else
          student = { status: 200, student: padawan }
        end
      else
        student = { status: 400 }
      end
    else
      student = { status: 400 }
    end
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
          field = field.split(',')
          courses = student[field_name]
          unless courses
            courses = String.new
          end
          courses = courses.split(',')
          field.each do |f|
            courses << f.to_s
          end
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
          student[field_name] = field
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
    render json: field
  end

  def delete_field
    student = Student.find(params[:student_id]) rescue nil
    if student
      field_name = params[:field].to_sym
      if LIST_FIELDS.include? field_name
        courses = student[field_name]
        if courses
          courses = courses.split(',')
          pupil = params[:student]
          field = pupil[field_name]
          if field
            field = field.split(',')
            deleted = false
            field.each do |f|
              if courses.delete(f)
                deleted = true
              end
            end
            if deleted
              courses = courses.join(',')
              student[field_name] = courses
              student.save
            end
          end
        else
          student[field_name] = String.new
          student.save
        end
        field = { status: 200, field_name => student[field_name] }
      else
        field = { status: 400 }
      end
    else
      field = { status: 400 }
    end
    render json: field
  end
end
