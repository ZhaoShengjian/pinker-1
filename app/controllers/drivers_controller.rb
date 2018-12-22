class DriversController < ApplicationController
 # before_action :logged_in_user, only: [:index ,:edit, :update]
 # before_action :correct_user,   only: [:edit, :update]
  def index
  end
  
  def show
    @user = Driver.find(params[:id])
  end
  def new
    @user = Driver.new
  end
  def edit
    @user = Driver.find(params[:id])
  end
  
  def update
    @user = Driver.find(params[:id])
    if @user.update_attributes(driver_params)
      flash[:success] = "Profile updated"
      redirect_to @user
      else
      render 'edit'
    end
  end
  def create
    @user = Driver.new(driver_params)
    @user.pass = false
    @user.id_card = @@driver_id_card_default
    @user.license = @@driver_license_default
    @user.head = @@driver_head_default
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
    
  def upload
    uploadFile(params[:file][:filedata])
  end
  
  def uploadFile(file)
    @filename = 'a.png'
    File.open("#{Rails.root}/assets/images/#{@filename}", "wb") do |f|
        f.write(file.read)# 向dir目录写入文件
      end
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
