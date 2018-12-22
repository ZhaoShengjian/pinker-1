class DriversController < ApplicationController
 # before_action :logged_in_user, only: [:index ,:edit, :update]
 # before_action :correct_user,   only: [:edit, :update]
  def index
  end
  
  def show
    @user = Driver.find(params[:id])
    @head = @user.head
    @id_card = @user.id_card
    @license = @user.license
  end
  def new
    @user = Driver.new
  end
  def edit
    @user = Driver.find(current_user.id)
    @head = @user.head
    @id_card = @user.id_card
    @license = @user.license
  end
  
  def update
    @user = Driver.find(params[:id])
    @user.update_attribute(:name, params[:driver][:name])
    @user.update_attribute(:sex, params[:driver][:sex])
    @user.update_attribute(:phone, params[:driver][:phone])
    flash[:success] = 'Success update infomation'
    redirect_to root_url
  end
  
  def update_head
    if params[:file].nil?
      return 
    end
    head = params[:file][:head]
    path = uploadHead(head)
    current_user.update_attribute(:head, path)
    flash[:success] = "Successful upload head"
    redirect_to root_url
  end
  
  def update_idcard
    if params[:file].nil?
      return
    end
    idcard = params[:file][:id_card]
    path =  uploadIdCard(idcard)
    current_user.update_attribute(:id_card, path)
    flash[:success] = "Successful upload idcard"
    redirect_to root_url
  end
  
  def update_carlicense
    if params[:file].nil?
      return
    end
    carlicense = params[:file][:license]
    path = uploadLicense(carlicense)
    current_user.update_attribute(:license,path)
    flash[:success] = "Successful upload license"
    redirect_to root_url
  end
  
  def uploadHead(head)
    filename = current_user.email + '.' + head.original_filename.split('.')[-1]
    path = Rails.root.join('public',  'upload','driver','head', filename)
    File.open(path, 'wb') do |file|
      file.write head.read
    end
    "/upload/driver/head/"+filename
  end
  
  def uploadIdCard(head)
    filename = current_user.email + '.' + head.original_filename.split('.')[-1]
    filepath = Rails.root.join('public', 'upload','driver','id_card', filename)
    current_user.id_card = filepath
    
    File.open(filepath, 'wb') do |file|
      file.write head.read
    end
    "/upload/driver/id_card/"+filename
  end
  
  def uploadLicense(head)
    filename = current_user.email + '.' + head.original_filename.split('.')[-1]
    filepath = Rails.root.join('public', 'upload','driver','license', filename)
    current_user.license = filepath
    
    File.open(filepath, 'wb') do |file|
      file.write head.read
    end
    "/upload/driver/license/"+filename
  end
  
  def create
    @user = Driver.new(driver_params)
    @user[:pass] = false
    @user[:id_card] = @@driver_id_card_default
    @user[:license] = @@driver_license_default
    @user[:head] = @@driver_head_default
    if @user.save
      flash[:success] = "Success Sign up!"
      log_in @user
      redirect_to root_url
    else
      flash[:danger] = @user.errors.full_messages.first
      redirect_to action: 'new'
    end
  end
  
  def driver_params
    params.require(:driver).permit(:name,:sex,:phone,:password,
      :email,:password_confirmation,:bond)
  end
  
  def take_order
    @order = Order.find(params[:id])
    @order.update_attribute(:driver_id, current_user.id)
    flash[:success] = 'Success take order!'
    redirect_to root_url
  end
  
  def accept_orders
    @key = Search.new
    @controller = 'drivers'
    @action = 'taken_order'
    @orders = current_user.orders.where(driver_finished: false).paginate(page: params[:page],per_page: 5)
    @orders = search @orders
    
  end
  
  def finished_orders
    @key = Search.new
    @controller = 'drivers'
    @action = 'finished_order'
    @orders = current_user.orders.where(driver_finished: true,student_finished:false).paginate(page: params[:page],per_page: 5)
    @orders = search @orders
    
  end
  
  def history_orders
    @key = Search.new
    @controller = 'drivers'
    @action = 'history_orders'
    @orders = current_user.orders.where(driver_finished: true,student_finished:true).paginate(page: params[:page],per_page: 5)
    @orders = search @orders
  end
  def order_params
    params.require(:order).permit(
      :number, :time, :destination
      )
  end
  
  def finish_order
    @order = Order.find(params[:id])
    @order.update_attribute(:driver_finished,true)
    flash[:success] = "成功完成！"
    redirect_to root_url
  end 
  
  
  def logged_in_user
      unless logged_in?
        flash[:danger] = "请登录！"
        redirect_to login_url
      end
  end
  
  def correct_user
      @user = Driver.find(params[:id])
      redirect_to(root_url) unless @user == current_user
  end
  
  
end
