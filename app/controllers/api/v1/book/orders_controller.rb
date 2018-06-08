module Api::V1::Book
  class Api::V1::Book::OrdersController < ApiController
    before_action :set_book

    def create
      @current_user = AuthorizeApiRequest.call(request.headers).result
      if @current_user
        # check if book is available and approved or not
        if ((@book.is_available.eql? true) && (@book.is_approved.eql? true)) 
          # check book transcation
          if @book.transcation.eql? "Free Share"
            @order = @book.orders.new(:book_id => @book.id, :user_id => @current_user.id, :state => 0, :seller => @book.user_id, :transcation => @book.transcation, :price => @book.price)
          elsif @book.transcation.eql? "Sell"
            # check if quantity exist, larger than zero and less than book quantity 
            if ((params[:quantity]) && (params[:quantity].to_i < @book.quantity) && (params[:quantity].to_i > 0))
              @order = @book.orders.new(:book_id => @book.id, :user_id => @current_user.id, :state => 0, :seller => @book.user_id, :transcation => @book.transcation, :price => @book.price * params[:quantity].to_i, :quantity => params[:quantity].to_i)
            else
              render json: {status: 'FAIL', message: 'This Quantity not valid', error:@book.errors},status: :ok
            end  
          end  
          # check if order created or not
          if @order
            # save order and check it saved successfuly
            if @order.save
              ###notification to book owner
              render json: {status: 'SUCCESS', message: 'order successfully created', order: @order},status: :ok
            else
              render json: {status: 'FAIL', message: 'Couldn\'t create order', error:@order.errors},status: :ok
            end
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
