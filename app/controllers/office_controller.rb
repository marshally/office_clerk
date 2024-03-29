class OfficeController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_clerk , :current_basket , :current_basket_or_nil
  helper OfficeHelper
  include OfficeClerk::Engine.routes.url_helpers

  # users are stored in the session by email
  # if user is not logged i , return nil
  def current_clerk
    return @current_clerk if @current_clerk
    return nil unless session[:clerk_email]
    @current_clerk = Clerk.where( :email => session[:clerk_email] ).limit(1).first 
  end

  def error
    logger.info "Error" + request.url
    redirect_to "/"
  end

  def current_basket_or_nil
    return @current_basket unless @current_basket.nil?
    if session[:current_basket]
      Basket.where( :id => session[:current_basket] ).limit(1).first 
    else
      nil
    end
  end
  # the current user has a shopping basket which is also stored in the session
  # we *always* return a basket, even if we have to create one (and then store in the session)
  # this is not associated with the user until an order is finalized at which point the order gets the users email (not id)
  # that way people don't have to log in to order, but if they are we can retrieve their orders by email
  def current_basket
    @current_basket = current_basket_or_nil
    if @current_basket.nil?
      @current_basket = Basket.new(:kori_type => "Order")
      @current_basket.save!
      session[:current_basket] = @current_basket.id
    end
    @current_basket
  end

  private
  # when the order is made and the basket locked, it's time to make a new one
  def new_basket
    session[:current_basket] = nil
  end
end
