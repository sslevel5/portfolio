class Public::TalkRoomsController < ApplicationController
  before_action :authenticate_customer!
  before_action :correct_customer

  def new
    # 新しいメッセージを作成するためのフォームを表示するためのアクション
    @talk_room = TalkRoom.sendhoge(current_customer.id, params[:against_customer_id] )
    redirect_to talk_rooms_path(id: @talk_room.id, against_customer_id: params[:against_customer_id])
  end

  def create
    recipient = Customer.find(params[:recipient_id])
    @talk_room = TalkRoom.find_or_create_by(sender_id: current_customer.id, recipient_id: recipient.id)
    redirect_to public_talk_room_path(@talk_room)
  end

  def index
    @customer = current_customer
    @talk_rooms = TalkRoom.where("sender_id = ? OR recipient_id = ?", current_customer.id, current_customer.id)
  end

  def show
    @customer = current_customer
    @against_customer = Customer.find(params[:against_customer_id])
    #talk_room = TalkRoom.find_by(sender_id: current_customer.id, recipient_id: @against_customer.id) || TalkRoom.find_by(sender_id: @against_customer.id, recipient_id: current_customer.id)
    @talk_room = TalkRoom.find(params[:id])
    @talk_room.reset_unread_messages_count(@against_customer) # 未読メッセージ数をリセットする
  end

  def senders
    customer = Customer.find(params[:id])
    @customers = customer.sending_customers
  end

  private

  def talk_room_params
    params.require(:talk_room).permit(:message)
  end

  def correct_customer
    if params[:id]
      @talk_room = TalkRoom.find_by(id: params[:id])
      if @talk_room.nil?
        render 'layouts/notfind'
        return
      else
        @customer = current_customer
      end
      redirect_to(public_talk_rooms_path) unless @talk_room.sender == @customer || @talk_room.recipient == @customer
    end
  end
end
