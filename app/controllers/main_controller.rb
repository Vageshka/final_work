class MainController < ApplicationController
  before_action :pars_params, only: [:create]
  skip_before_action :unauthenticate, except: [:create, :new]
  skip_before_action :authenticate, only: [:new,:create,:index]
  before_action :set_student, only: [:edit]
  before_action :set_company, only: [:edit]

  #Main page
  def index
  end

  #Sign up page
  def new
  end

  #Creating new user
  def create
    user = User.new do |t|
      t.login = @login
      t.password = @password
      t.password_confirmation = @password_confirmation
      t.company = @company
    end
    if user.save
      redirect_to session_new_path
    else
      flash[:error] = user.errors.full_messages
      redirect_to main_new_path
    end
  end

  #Page of filling student/company model
  def edit
    if @_current_user.company
      render "edit_company"
    else
      render "edit_student"
    end
  end

  #Action of filling student/company model
  def update
    if @_current_user.company
      company = Company.find_by_user_id(session[:current_user_id])
      if company
        company.update(pars_params_company) ? status = "ok" : status = "error"
      else
        company = Company.new(pars_params_company)
        company.save ? status = "ok" : status = "error"
      end

    else
      student = Student.find_by_user_id(session[:current_user_id])
      if student
        student.update(pars_params_student) ? status = "ok" : status = "error"
      else
        student = Student.new(pars_params_student)
        student.save ? status = "ok" : status = "error"
      end
    end

    flash.now[:status] = status == "ok" ? "Successfully updated." : company.errors.full_messages
    set_student
    set_company
    render "edit#{company ? "_company" : "_student"}"
  end

  def companies
  end

  def comp_show
  end

  def students
  end

  def all_companies
    @companies=[]
    Company.all
    .each do |comp|
      choosed = Offer.where(student_id: set_student.id).find_by_company_id(comp.id) ? "yes" : "no"
      @companies << {id: comp.id, name: comp.name, choosed: choosed}
    end
  end

  def offer_to_company
    unless Offer.find_by(student_id: set_student.id, company_id: params[:id])
      offer = Offer.new(student_id: set_student.id, company_id: params[:id])
      respond_to do |f|
        f.json {render json: {success: (offer.save ? true : false), error: offer.errors.full_messages }}
      end
    end
  end

  def company_discibtion
    company = Company.find_by_id(params[:id])
    respond_to do |f|
      f.json {render json: {id: params[:id].to_s, vacancy: company.vacancy, requirements: company.requirements,conditions: company.conditions}}
    end
  end

  def choosed_companies
    @companies=[]
    Company.where(id: Offer.where(student_id: session[:current_user_id]).select(:company_id))
    .each do |comp|
      @companies << {id: comp.id, name: comp.name}
    end
  end

  def cancel_offer
    offer = Offer.find_by(student_id: set_student.id, company_id: params[:id])
    if offer
      respond_to do |f|
        f.json do
          render json:
          if offer.delete
            { success: true, action: "delete" }
          else
            { success: false, error: offer.errors.full_messages }
          end
        end
      end
    else
      respond_to do |f|
        render json: {error: "Unfound"}
      end
    end
  end

  def all_db
    respond_to do |f|
      f.json { render json: {users: User.all, stud: Student.all, comp: Company.all, offers: Offer.all} }
    end
  end


  def stud_show
  end

  def get_file
    file_path = "#{Rails.root}/public/uploads/#{params[:id].to_s}-example.pdf"
    if File.exists? file_path
      send_file(file_path) #, disposition: :inline)
    else
      flash[:status] = "File not found"
      redirect_back fallback_location: root_path
    end
  end

  private

  def pars_params
    @login = params[:login]
    @password = params[:password]
    @password_confirmation = params[:password_confirmation]
    @company = params[:company] == "student" ? false : true
  end

  def set_student
    @student = Student.find_by_user_id(session[:current_user_id])
    #@student ||=
  end

  def pars_params_student
    upload if params[:file]
    params.permit(:fullname, :departament, :group, :wish, :file).merge(user_id: session[:current_user_id])
  end

  def upload
    uploaded_file = params[:file]
    File.open(Rails.root.join('public', 'uploads', set_student.id.to_s+"-example.pdf"), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    params[:file] = nil
    params.delete(:file)
  end

  def set_company
    @company = Company.find_by_user_id(session[:current_user_id])
    #@student ||=
  end

  def pars_params_company
    params.permit(:name, :vacancy, :requirements, :conditions).merge(user_id: session[:current_user_id])
  end
end
