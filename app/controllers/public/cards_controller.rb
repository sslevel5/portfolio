class Public::CardsController < ApplicationController
 before_action :authenticate_customer!, only: [:new, :create, :edit, :update]
 before_action :correct_customer, only: [:edit, :update]
 before_action :nul_card, only: [:edit, :update, :show]

 def new
  @card = Card.new
  @raritys = Rarity.all
  @stores = Store.all
 end

 def index
  @card = Card.new #モーダル用
  @raritys = Rarity.all
  @stores = Store.all
  @cards = Card.search(params[:q]).by_rarity(params[:rarity_id]).by_store(params[:store_id]).where(is_active: true).send(sort_order)
 end

 def create
  @card = Card.new(card_params)
  @raritys = Rarity.all
  @stores = Store.all
  @card.customer_id = current_customer.id
  if @card.save
   flash[:notice] = "投稿しました。"
   redirect_to public_card_path(@card.id)
  else
   flash.now[:alert] = "投稿に失敗しました。"
   render :new
  end
 end

 def show
  @card = Card.new #モーダル用
  @raritys = Rarity.all
  @stores = Store.all
  @card = Card.find(params[:id])
  @card_comment = CardComment.new
  @card_comments = CardComment.all
 end

 def edit
  @card = Card.find(params[:id])
  @raritys = Rarity.all
  @stores = Store.all
 end

 def update
  @card = Card.find(params[:id])
  @raritys = Rarity.all
  @stores = Store.all
  if @card.update(card_params)
   flash[:notice] = "変更しました。"
   redirect_to public_card_path(@card.id)
  else
   flash.now[:alert] = "変更に失敗しました。"
   render :edit
  end
 end


 private

 def card_params
  params.require(:card).permit(:rarity_id, :store_id, :title, :body, :price, :is_active, :image)
 end

 def sort_order
   case params[:sort_by]
   when 'latest'
     :latest
   when 'old'
     :old
   when 'high_price'
     :high_price
   when 'low_price'
     :low_price
   else
     :latest
   end
 end

  def correct_customer
    @card = Card.find(params[:id])
    @customer = @card.customer
    redirect_to(public_cards_path) unless @customer == current_customer
  end

  def nul_card
    if params[:id]
      @card = Card.find_by(id: params[:id])
      if @card == nil
        @raritys = Rarity.all
        @stores = Store.all
        render 'layouts/notfind'
      end
    end
  end

end
