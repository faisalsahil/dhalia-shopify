class SessionsController < ApplicationController
  def new
    authenticate if params[:shop].present?
  end

  def create
    puts "=================create ============================="
    authenticate
  end
  
  def show
    if response = request.env['omniauth.auth']
      sess = ShopifyAPI::Session.new(params[:shop], response['credentials']['token'])
      session[:shopify] = sess        
      flash[:notice] = "Logged in"
      redirect_to return_address
    else
      flash[:error] = "Could not log in to Shopify store."
      redirect_to :action => 'new'
    end
  end
  
  def destroy
    session[:shopify] = nil
    flash[:notice] = "Successfully logged out."
    
    redirect_to :action => 'new'
  end
  
  protected
  
  def authenticate
    puts "===================authenticate =================================="
    puts params
    # aa = sanitize_shop_param(params)
    # puts aa
    if shop_name = sanitize_shop_param(params)
      puts"======================in if ======================================"
      redirect_to "/auth/shopify?shop=#{shop_name}"
      puts "================================================================="
    else
      puts "================ else ==========================================="
      redirect_to return_address
    end
  end
  
  def return_address
    session[:return_to] || root_url
  end
  
  def sanitize_shop_param(params)
    return unless params[:shop].present?
    puts "-----------------------------------------------------------------"
    name = params[:shop].to_s.strip
    puts name
    puts "-----------------------------------------------------------------"
    name += '.myshopify.com' if !name.include?("myshopify.com") && !name.include?(".")
    name.sub('https://', '').sub('http://', '')

    u = URI("http://#{name}")
    u.host.ends_with?("myshopify.com") ? u.host : nil
  end
end