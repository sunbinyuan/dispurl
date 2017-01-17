class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:default, :redir, :create]
  # GET /
  def default
    if user_signed_in? 
        redirect_to urls_path
    end
    @url = Url.new
  end
  
  # GET /alias
  def redir
    str_alias = params[:alias]
    link = Url.find_by({alias: str_alias})
    if link != nil
    link.views += 1
      case link.redir_id
      when 0
        raise ActiveRecord::RecordNotFound
      when 1
      when 2
        if link.views >= link.redir_limit
          link.redir_id = 0
        end

      else
      end
        link.save
        redirect_to link.redirect_to, :status => :moved_permanently
    else
      raise ActiveRecord::RecordNotFound
      
      # render :file => "#{Rails.root}/public/404.html",  :status => 404
      # raise ActionController::RoutingError.new('Not Found')
    end
    # respond_to do |format|
      # format.html { render :text => link }
    # end
  end

  # GET /urls
  # GET /urls.json
  def index
    
    #@urls = Url.all#current_user.urls.all
    get_urls
    @url = Url.new
  end

  # GET /urls/1
  # GET /urls/1.json
  # def show
  # end

  # GET /urls/new
  def new
    @url = Url.new
  end

  # GET /urls/1/edit
  def edit
    if @url.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to urls_path, notice: 'You don\'t have permission to edit this url.' }
        format.json { render :show, status: :ok, location: urls_path }
      end
    end
  end

  # POST /urls
  # POST /urls.json
  def create
    param_name = url_params[:name]
    param_redirect_to = Url.clean_url(url_params[:redirect_to])
    param_alias = url_params[:alias]
    redir_id = 1
    
    if !url_params[:redir_val1].blank?
      redir_id += 1
    end
    param_redir_limit = (url_params[:redir_limit].blank? ? '1' : url_params[:redir_limit].dup )

    if param_alias.blank?
      param_alias = Url.generate_alias.dup
    end
    
    @url = Url.new({name: param_name, redirect_to: param_redirect_to, alias: param_alias,
       user_id: user_signed_in? ? current_user.id : nil, redir_id: redir_id, redir_limit: param_redir_limit})
       
    respond_to do |format|
      if @url.save
        format.html { redirect_to request.referer, notice: 'Your URL is: ' + request.base_url + '/' + @url.alias}
        format.json { render :show, status: :created, location: request.referer }
      else
        format.html { render user_signed_in? ? :index : :default }
        format.json { render json: @url.errors, status: :unprocessable_entity }
        if user_signed_in?
          get_urls
        end
      end
    end
  end

  # PATCH/PUT /urls/1
  # PATCH/PUT /urls/1.json
  def update
    respond_to do |format|
      if @url.user_id == current_user.id
        param_name = url_params[:name]
        param_redirect_to = Url.clean_url(url_params[:redirect_to])
        param_alias = url_params[:alias]
        redir_id = 1
        
        if !url_params[:redir_val1].blank?
          redir_id += 1
          redir_limit = (url_params[:redir_limit].blank? ? 1: url_params[:redir_limit].to_i)
        end
        
        if @url.update({name: param_name, redirect_to: param_redirect_to,
        redir_id: redir_id, redir_limit: redir_limit})
          format.html { redirect_to request.referer, notice: 'Url was successfully updated.' }
          format.json { render :show, status: :ok, location: request.referer }
        else
          format.html { render :edit }
          format.json { render json: @url.errors, status: :unprocessable_entity }
        end
        
      else
        format.html { redirect_to urls_path, notice: 'You don\'t have permission to edit this url.' }
        format.json { render :show, status: :ok, location: urls_path }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    if @url.user_id == current_user.id
      @url.destroy
      respond_to do |format|
        format.html { redirect_to urls_url, notice: 'Url was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to urls_url, notice: 'You don\'t have permission to delete this url.' }
        format.json { head :no_content }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end
    
    def get_urls
      @urls = current_user.urls.order(redir_id: :desc).all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
    	if user_signed_in?
	      params.require(:url).permit(:name, :redirect_to, :alias, :redir_val1, :redir_limit)
    	else
	      params.require(:url).permit(:redirect_to, :redir_val1)
    	end
    end
end
