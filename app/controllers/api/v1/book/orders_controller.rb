module Api::V1::Book
  class Api::V1::Book::OrdersController < ApiController
    before_action :set_book

    def create
      @current_user = AuthorizeApiRequest.call(request.headers).result
      if @current_user
        if @book.is_available.eql? true
          if @book.transcation.eql? "Free Share"
            @order = @book.orders.new(:book_id => @book.id, :user_id => @current_user.id, :state => 0, :seller => @book.user_id, :transcation => @book.transcation, :price => @book.price)
            if @order.save
              ###notification to book owner
              render json: {status: 'SUCCESS', message: 'order successfully created', order: @order},status: :ok
            else
              render json: {status: 'FAIL', message: 'Couldn\'t create order', error:@order.errors},status: :ok
            end
          elsif @book.transcation.eql? "Sell"  
            
          end
        else
          render json:{status: 'FAIL', message: 'This book not available', error:@book.errors},status: :ok
        end 
      end    
    end  

    private
    def set_book
      @book = Book.find(params[:book_id])
    end
  end
end
