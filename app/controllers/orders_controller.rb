# encoding : utf-8
class OrdersController < AdminController

  before_filter :load_order, :only => [:show, :edit, :update , :pay , :ship , :mail]

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    @q = Order.search(params[:q])
    @order_scope = @q.result( :distinct => true)
    @orders = @order_scope.includes(:basket => :items ).paginate(:page => params[:page],:per_page => 20)
  end

  def show
    gon.order_id = @order.id
  end

  def new
    @order = Order.new
    @order.build_basket
    render :edit
  end

  def mail
    action = params[:act]
    puts "MAIL #{action}"
    mail = eval("OrderMailer.#{action}(@order)")
    mail.deliver
    flash.notice = "Sent #{action}"
    redirect_to :action => :show
  end
  def pay
    @order.paid_on = Date.today
    @order.save!
    render :show
  end
  def ship
    return if request.get?
    order_ps = params.require(:order).permit( :email,:name , :street , :city , :phone , :shipment_type )
    order_ps[:shipped_on] = Date.today
    if @order.update_attributes(order_ps)
      redirect_to order_path(@order), :notice => t(:OK)
      return
    end
  end
  
  def edit
  end

  def create
    @order = Order.create(params_for_model)
    @order.build_basket() unless @order.basket
    if @order.save
      redirect_to order_path(@order), :notice => t(:create_success, :model => "order")
    else
      render :edit
    end
  end

  def update
    @order.build_basket unless @order.basket
    if @order.update_attributes(params_for_model)
      redirect_to order_path(@order), :notice => t(:update_success, :model => "order")
    else
      render :action => :edit
    end
  end

  private

  def load_order
    @order = Order.find(params[:id])
  end

  def params_for_model
    params.require(:order).permit(:ordered_on,:shipment_price,:shipment_tax,:basket_id,:email,:paid_on,:shipped_on,:paid_on,:canceled_on,:shipment_type)
  end
end

