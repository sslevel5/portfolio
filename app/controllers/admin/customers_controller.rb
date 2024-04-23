class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  before_action :nul_customer, only: [:edit, :update, :show]

  def index
   @raritys = Rarity.all
   @stores = Store.all
    @customers = Customer.all
  end

  def show
   @raritys = Rarity.all
   @stores = Store.all
    @customer = Customer.find(params[:id])
  end

  def edit
   @raritys = Rarity.all
   @stores = Store.all
    @customer = Customer.find(params[:id])
  end

  def update
   @raritys = Rarity.all
   @stores = Store.all
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to admin_customer_path(@customer), notice: "顧客情報が正常に更新されました"
    else
      render :edit
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name ,:profile_image ,:introduction ,:email, :password, :password_confirmation)
  end

   def nul_customer
    if params[:id]
      @customer = Customer.find_by(id: params[:id])
      if @customer == nil
        @raritys = Rarity.all
        @stores = Store.all
        render 'layouts/notfind'
      end
    end
   end

end
