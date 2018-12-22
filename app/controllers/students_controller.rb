class StudentsController < ApplicationController
  def show
    @user = Student.find(params[:id])
    @head = @user.head
    @id_card = @user.id_card
  end
  def new
    @user = Student.new
  end
  def create
    @user = Student.new(student_params)
    @user[:pass] =false
    @user[:id_card] = @@student_id_card_default
    @user[:head] = @@student_head_default
    if @user.save
      flash[:success] = "Success Sign up!"
      log_in @user
      redirect_to root_url
    else
      flash[:danger] = @user.errors.full_messages.first
      redirect_to action: 'new'
    end
  end
  
  def student_params
    params.require(:student).permit(
      :name,:sex,:phone,:password,
        :email,:password_confirmation
      )
  end
  def edit
    @user  = Student.find(current_user.id)
    @head  = @user.head
    @id_card = @user.id_card
  end
  def update
    @user = Student.find(params[:id])
    @user.update_attribute(:name, params[:student][:name])
    @user.update_attribute(:sex, params[:student][:sex])
    @user.update_attribute(:phone, params[:student][:phone])
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
  def uploadHead(head)
    filename = current_user.email + '.' + head.original_filename.split('.')[-1]
    path = Rails.root.join('public',  'upload','student','head', filename)
    File.open(path, 'wb') do |file|
      file.write head.read
    end
    "/upload/student/head/"+filename
  end
  def uploadIdCard(head)
    filename = current_user.email + '.' + head.original_filename.split('.')[-1]
    filepath = Rails.root.join('public', 'upload','student','id_card', filename)
    current_user.id_card = filepath
    
    File.open(filepath, 'wb') do |file|
      file.write head.read
    end
    "/upload/student/id_card/"+filename
  end
  def user_params
    params.require(:file).permit(
      :head, :id_card
      )
    params.require(:user).permit(
      :name, :sex, :phone
      )
  end
  def new_order
    @order = Order.new
    
  end
  def create_order
    @order = Order.new(order_params)
    @order.finished = false
    @order.cur_number = 1
   
    if @order.save
      flash[:success] = "Success create order!"
      so = StudentOrder.new(student_id: current_user
      .id, order_id:@order.id, bond:100.0, is_creator:true)
       so.save
      redirect_to root_url
     
      
    else
      flash[:danger] = @order.errors.full_messages.first
      redirect_to action: 'new_order'
      
    end
  end
  def order_params
    params.require(:order).permit(
      :number, :time, :destination
      )
  end
  
  def join_order
    order = Order.find(params[:id])
    if !order.nil?
      res = StudentOrder.find_by(order_id: order.id, student_id: current_user.id)
      if !res.nil?
        flash[:danger] = "Can't join this order!"
        redirect_to root_url
        return
      end
      if order.cur_number < order.number
        order.cur_number += 1 
        StudentOrder.create(student_id: current_user
        .id, order_id: order.id, bond:100.0, is_creator:false)
        order.save
        flash[:success] = "Success Join!"
        redirect_to root_url
      else
        flash[:danger] = "Can't join this order!"
        redirect_to root_url
      end
    end
  end
  def current_orders
    @key = Search.new
    @controller = 'students'
    @action = 'current_orders'
    @orders = current_user.orders.where(driver_id: nil).paginate(page: params[:page],per_page: 5)
    @orders = search @orders
  end
  
  def accept_orders
    @key = Search.new
    @controller = 'students'
    @action = 'accept_orders'
    @orders = current_user.orders.where(driver_id: !nil).paginate(page: params[:page],per_page: 5)
    @orders = search @orders
  end
  
  def history
    @key = Search.new
    @controller = 'students'
    @action = 'history'
    @orders = current_user.orders.where(finished: true).paginate(page: params[:page],per_page: 5)
    @orders = search @orders
  end 
  
  def edit_order
    @order = Order.find(params[:id])
  end
  
  def update_order
    @order = Order.find(params[:id])
    @order.number = params[:order][:number]
    @order.save
    flash[:success] = "Success update order!"
    redirect_to root_url
  end
  
  def delete_order
    @order = Order.find(params[:id])
    StudentOrder.find_by(student_id: current_user.id, order_id: @order.id).delete
    @order.delete
    flash[:success] = 'Success Delete order!'
    redirect_to root_url
  end
  
  def quit_order
    @order = Order.find(params[:id])
    so = StudentOrder.find_by(student_id: current_user.id, order_id: @order.id)
    if so.is_creator?
      if @order.cur_number == 1
        so.delete
        @order.delete
      else
        so.delete
        s = @order.students.first
        soo = StudentOrder.find_by(student_id: s.id, order_id: @order.id)
        soo.is_creator = true
        soo.save
        @order.cur_number -= 1
        @order.save
      end
      flash[:success] = 'Success quit!'
      redirect_to root_url
    else
      @order.cur_number -= 1
      so.delete
      @order.save
      flash[:success] = 'Success quit!'
      redirect_to root_url
    end
  end
  def driver_info
    @order = Order.find(params[:id])
    @driver = Driver.find(@order.driver_id)
    {name: @driver.name, phone: @driver.phone, cars: @driver.cars, head: @driver.head}
  end
    
end
