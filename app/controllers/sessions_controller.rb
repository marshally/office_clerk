class SessionsController < OfficeController
  layout "sales_clerk"

  def sign_in
  end

  def create
    clerk = Clerk.where(:email => params[:email]).limit(1).first
    if clerk && clerk.valid_password?(params[:password])
      session[:clerk_email] = clerk.email
      url = clerk.admin ?  office.baskets_url : root_url
      redirect_to url , :notice => I18n.t(:signed_in)
    else
      redirect_to :sign_in , :notice => I18n.t(:sign_in_invalid)
    end
  end

  def sign_out
    session[:clerk_email] = nil
    redirect_to root_url, :notice => I18n.t(:signed_out)
  end

  def sign_up
    if request.get?
      @clerk = Clerk.new
    else
      @clerk = Clerk.new(params_for_clerk)
      if @clerk.save
        session[:clerk_email] = @clerk.email
        redirect_to root_url, :notice => "Signed up!"
        return
      end
    end
  end
  def params_for_clerk
    params.require(:clerk).permit(:email,:password,:password_confirmation)
  end

end
