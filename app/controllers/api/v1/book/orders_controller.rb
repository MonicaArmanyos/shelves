module Api::V1::Book
  class Api::V1::Book::OrdersController < ApiController
    before_action :set_book, except: :exchange_request

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
              @seller=User.find(@order.seller)
              @category=Category.find(@book.category_id)
              render json: {status: 'SUCCESS', message: 'order successfully created', order: {id: @order.id, state: @order.state, transcation: @order.transcation, price: @order.price, quantity: @order.quantity}, book: {id: @book.id, name: @book.name, description: @book.description, rate: @book.rate, price: @book.price}, category:{id: @category.id, name: @category.name}, seller: {id: @seller.id, name: @seller.name}},status: :ok
            else
              render json: {status: 'FAIL', message: 'Couldn\'t create order', error:@order.errors},status: :ok
            end
          end   
        else
          render json:{status: 'FAIL', message: 'This book not available', error:@book.errors},status: :ok
        end 
      end    
    end  

      ##After user chooses the books he agreed to exchange
      def exchange_request
        render json:{status: 'FAIL', message: params[:id]},status: :ok
        #send_notification(current_user,"Book exchange request", "https://")
       end

    private
    def set_book
      @book = Book.find(params[:book_id])
    end
  end
end
