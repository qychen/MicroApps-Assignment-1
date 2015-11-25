class StudentsController < ApplicationController
  protect_from_forgery with: :null_session

  def read
    render json: { status: 200, params: params }
  end
end
