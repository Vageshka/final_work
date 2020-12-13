class MainController < ApplicationController
  before_action :pars_params, only: [:create]
  skip_before_action :unauthenticate, except: [:create, :new]
  skip_before_action :authenticate, only: [:new,:create,:index]
  before_action :set_student, only: [:edit, :students]
  before_action :set_company, only: [:edit]
  before_action :only_students, only: [:all_companies, :choosed_companies, :waiting_approval]
  before_action :only_companies, only: [:all_applications, :pending_confirmations, :approved]


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

  #page for companies
  def companies
  end

  #page with student's application
  def all_applications
    @students = Student.where(id: Offer.where(company_id: set_company.id, comp_agree: false).select(:student_id))
  end

  #get student description
  def student_description
    student = Student.find_by_id(params[:id])
    respond_to do |f|
      f.json {render json: {id: params[:id].to_s, departament: student.departament, group: student.group}}
    end
  end

  #company accepts offer
  def accept_offer
    offer = Offer.find_by(company_id: set_company.id, student_id: params[:id])
    if offer
      respond_to do |f|
        f.json {render json: {success: (offer.update(comp_agree: true) ? true : false), error: offer.errors.full_messages }}
      end
    else
      respond_to do |f|
        f.json {render json: {success: false, error: "Unfound. Try to reload the page" }}
      end
    end
  end

  #List of pending confirmations students
  def pending_confirmations
    @students = Student.where(id: Offer.where(company_id: set_company.id, comp_agree: true, stud_agree: false).select(:student_id))
  end

  #cancel acceptance
  def cancel_acceptance
    offer = Offer.find_by(company_id: set_company.id, student_id: params[:id])
    if offer
      respond_to do |f|
        f.json {render json: {success: (offer.update(comp_agree: false) ? true : false), error: offer.errors.full_messages }}
      end
    else
      respond_to do |f|
        f.json {render json: {success: false, error: "Unfound. Try to reload the page" }}
      end
    end
  end

  #List of approved application (students related to the company)
  def approved
    @students = Student.where(id: Offer.where(company_id: set_company.id, comp_agree: true, stud_agree: true).select(:student_id))
  end

  #page for students
  def students
  end

  #page with all companies
  def all_companies
    @companies=[]
    Company.all
    .each do |comp|
      choosed = Offer.where(student_id: set_student.id).find_by_company_id(comp.id) ? "yes" : "no"
      @companies << {id: comp.id, name: comp.name, choosed: choosed}
    end
  end

  #student offer
  def offer_to_company
    unless Offer.find_by(student_id: set_student.id, company_id: params[:id])
      offer = Offer.new(student_id: set_student.id, company_id: params[:id])
      respond_to do |f|
        f.json {render json: {success: (offer.save ? true : false), error: offer.errors.full_messages }}
      end
    end
  end

  #get company description
  def company_description
    company = Company.find_by_id(params[:id])
    respond_to do |f|
      f.json {render json: {id: params[:id].to_s, vacancy: company.vacancy, requirements: company.requirements,conditions: company.conditions}}
    end
  end

  #all choosed comapnies
  def choosed_companies
    @companies=[]
    Company.where(id: Offer.where(student_id: set_student.id).select(:company_id))
    .each do |comp|
      @companies << {id: comp.id, name: comp.name}
    end
  end

  #cancel the offer
  def cancel_offer
    offer = Offer.find_by(student_id: set_student.id, company_id: params[:id])
    if offer
      respond_to do |f|
        f.json {render json: {success: (offer.destroy ? true : false), error: offer.errors.full_messages }}
      end
    else
      respond_to do |f|
        f.json {render json: {success: false, error: "Unfound. Try to reload the page" }}
      end
    end
  end

  #List of waiting for approval companies
  def waiting_approval
    @companies = Company.where(id: Offer.where(student_id: set_student.id, comp_agree: true).select(:company_id))
  end

  #Approving an internship at company
  def approve_company
    offer = Offer.find_by(student_id: set_student.id, company_id: params[:id], comp_agree: true)
    if offer
      if offer.update(stud_agree: true) && Offer.where(student_id: set_student.id).where.not(company_id: params[:id]).destroy_all
        respond_to do |f|
          f.json {render json: {success: true, error: offer.errors.full_messages }}
        end
      else
        respond_to do |f|
          f.json {render json: {success: false, error: offer.errors.full_messages }}
        end
      end
    else
      respond_to do |f|
        f.json {render json: {success: false, error: "Unfound. Try to reload the page" }}
      end
    end
  end

  def all_db
    respond_to do |f|
      f.json { render json: {users: User.all, stud: Student.all, comp: Company.all, offers: Offer.all} }
    end
  end

  #send student's file
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
  #checking user status (need student without company to continue)
  def only_students
    if @_current_user.company or Offer.find_by(student_id: set_student.id, stud_agree: true)
      redirect_to main_students_path
    end
  end

  #checking user status (need company to continue)
  def only_companies
    unless @_current_user.company
      redirect_to main_companies_path
    end
  end

  #user's params
  def pars_params
    @login = params[:login]
    @password = params[:password]
    @password_confirmation = params[:password_confirmation]
    @company = params[:company] == "student" ? false : true
  end

  #find student
  def set_student
    @student = Student.find_by_user_id(session[:current_user_id])
    #@student ||=
  end

  #student's params
  def pars_params_student
    upload if params[:file]
    params.permit(:fullname, :departament, :group, :wish, :file).merge(user_id: session[:current_user_id])
  end

  #upload file to public/uploads
  def upload
    uploaded_file = params[:file]
    File.open(Rails.root.join('public', 'uploads', set_student.id.to_s+"-example.pdf"), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    params[:file] = nil
    params.delete(:file)
  end

  #find company
  def set_company
    @company = Company.find_by_user_id(session[:current_user_id])
    #@company ||=
  end

  #company's params
  def pars_params_company
    params.permit(:name, :vacancy, :requirements, :conditions).merge(user_id: session[:current_user_id])
  end
end
