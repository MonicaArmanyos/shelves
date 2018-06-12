module Api::V1::Book
  class Api::V1::Book::OrdersController < ApplicationController
    before_action :set_book, except: [:exchange_request, :confirm_exchange, :dismiss_exchange]
    before_action :authenticate_request
    def create
     # @current_user = AuthorizeApiRequest.call(request.headers).result
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
              # notification to book owner
              @seller=User.find(@order.seller)
              body= "There is new order to your #{@book.name} book."
              click_action= "http://localhost:3000/api/v1/book/books/#{@book.id}/order/#{@order.id}"
              send_notification(@seller ,body , click_action)
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
        @order = Order.find(params[:id])
        if @order
        @exchangeable_books = params[:books]
        user = User.find(@order.seller_id)
        #send_notification( user,"Book exchange request", "https://google.com")
        render json:{status: 'Success', exchangeable_books: @exchangeable_books, wanted_book: @order.book_id, with: @order.user_id },status: :ok
        end
       end

       def confirm_exchange
        @order = Order.find(params[:id])
        if @order.state == "confirmed"
          render json:{status: 'FAIL', message: 'order has already been confirmed'},status: :ok
        else 
          @exchangeable_book = Book.find(params[:book])
          @order.exchangeable_book_id = @exchangeable_book.id
          @order.state = "confirmed"
          if @order.save
            user = User.find(@order.user_id)
            #send_notification(user, @order.user_id + " accepted to exchange books", "https://google.com")
            render json:{status: 'SUCCESS', message: 'Order to exchange book is confirmed', order: @order}, status: :ok
          end
        end
       end
       def dismiss_exchange
        @order = Order.find(params[:id])
        if @order.state == "confirmed"
          render json:{status: 'FAIL', message: 'order has already been confirmed'},status: :ok
        elsif @order.destroy!
          user = User.find(@order.user_id)
           #send_notification(user, @order.user_id + " doesn\'t want to exchange books", "https://google.com")
          render json:{status: 'SUCCESS', message: 'Order to exchange is cancelled'},status: :ok
        end
       end

      ####  Show order details ####
      def show 
        puts params[:id]
        @order = Order.find(params[:id])
        render json:{status: 'SUCCESS', message: 'Order details loaded successfully',order: @order},status: :ok
      end
       

    private
    def set_book
      @book = Book.find(params[:book_id])
    end
     #### Authentication of user ####
        def authenticate_request
            @current_user = AuthorizeApiRequest.call(request.headers).result
            render json: { error: 'Not Authorized' }, status: 401 unless @current_user
        end
  end
end
