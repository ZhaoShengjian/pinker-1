require 'date'
class IndexController < ApplicationController
  
  
  def index
    user = current_user.class.to_s
    pp 'mylog',params[:page]
    @orders = nil
    if user == 'Student' or user == 'NilClass'
      @orders = Order.paginate(:page=>params[:page],:per_page=>5).where('cur_number != number')
    elsif user == 'Driver'
      @orders = Order.paginate(:page=>params[:page],:per_page=>5).where(driver_id: nil).where("cur_number = number")
    elsif user == 'Manager'
      @orders = Order.paginate(:page=>params[:page],:per_page=>5).all
    else
      flash[:danger] = @orders.errors.full_messages.first
      redirect_to root_url
    end
    @key = Search.new
    @orders = search @orders
    @controller = 'index'
    @action = 'index'
    
  end
  def search_params
    params.require(:search).permit(
      :time,:destination
      )
  end
  def search_empty?
    params[:search].nil? or ( params[:search][:time].empty? and params[:search][:destination].empty?)
  end
  
  def new
  end
  def orders
   
  end
end
