module Api::V1::Book
  class Api::V1::Book::OrdersController < ApplicationController
    before_action :set_book, except: [:exchange_request, :confirm_exchange, :dismiss_exchange, :showOrders, :showOrder]
    before_action :authenticate_request
    before_action :set_order, only: [:set_order, :confirm_order, :dismiss_order]
    def create
     # @current_user = AuthorizeApiRequest.call(request.headers).result
      if @current_user
        # check if book is available and approved or not
        if ((@book.is_available.eql? true) && (@book.is_approved.eql? true)) 
          # check book transcation
          if @book.transcation.eql? "Free Share"
            @prev_order = Order.where(:book_id => @book.id, :user_id => @current_user.id, :state => 0, :seller_id => @book.user_id, :transcation => @book.transcation).first
            if @prev_order == nil
              @order = @book.orders.new(:book_id => @book.id, :user_id => @current_user.id, :state => 0, :seller_id => @book.user_id, :transcation => @book.transcation, :price => @book.price)
            else
              @order = @prev_order
              
            end 
          elsif @book.transcation.eql? "Sell"
            @prev_order = Order.where(:book_id => @book.id, :user_id => @current_user.id, :state => 0, :seller_id => @book.user_id, :transcation => @book.transcation).first
            # check if quantity exist, larger than zero and less than book quantity 
            if ((params[:quantity]) && (params[:quantity].to_i <= @book.quantity) && (params[:quantity].to_i > 0))
              @book.quantity =  @book.quantity - params[:quantity].to_i
              # check quantity of the book then update is available
              if (@book.quantity == 0)
                @book.is_available = 0
              end 
              if @book.save
                 @prev_order = Order.where(:book_id => @book.id, :user_id => @current_user.id, :state => 0, :seller_id => @book.user_id, :transcation => @book.transcation).first
                  if @prev_order == nil
                    @order = @book.orders.new(:book_id => @book.id, :user_id => @current_user.id, :state => 0, :seller_id => @book.user_id, :transcation => @book.transcation, :price => @book.price * params[:quantity].to_i, :quantity => params[:quantity].to_i) 
                  else
                    @order = @prev_order
                    
                  end 
                
              else
                render json: {status: 'FAIL', message: 'Order can\'t created, try again', error:@book.errors},status: :ok
              end  
            else
              render json: {status: 'FAIL', message: 'This Quantity not valid', error:@book.errors},status: :ok
            end  
          end  
          # check if order created or not
          if @order
            # save order and check it saved successfuly
            if @order.save
              if @order.notification_sent == true
                render json:  {status: 'FAIL',message: 'You already ordered this book'},status: :ok
               else
              # notification to book owner
              @seller=User.find(@order.seller_id)
              @sender_user=@current_user
              body= "There is new order to your #{@book.name} book."
              click_action= "http://localhost:4200/order/#{@order.id}"
              TasksController.send_notification(@seller,@sender_user ,body , click_action)
              @category=Category.find(@book.category_id)
              @order.notification_sent = true
              @order.save
              render json: {status: 'SUCCESS', message: 'order successfully created', order: {id: @order.id, state: @order.state, transcation: @order.transcation, price: @order.price, quantity: @order.quantity}, book: {id: @book.id, name: @book.name, description: @book.description, rate: @book.rate, price: @book.price}, category:{id: @category.id, name: @category.name}, seller: {id: @seller.id, name: @seller.name}},status: :ok
               end
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
          puts @exchangeable_books
          @order.exchangeable_books = @exchangeable_books.to_json
          user = User.find(@order.seller_id)
          @order.notification_sent = true
          @order.save
          TasksController.send_notification(user,@current_user,"Book exchange request", "http://localhost:4200/order/#{@order.id}")
          render json:{status: 'Success', message: "Your request is sent to book owner ("+user.name+")"}, status: :ok
        end
       end

       def confirm_exchange
        @order = Order.find(params[:id])
        if @order.state == "confirmed"
          render json:{status: 'FAIL', message: 'order has already been confirmed'},status: :ok
        else 
          @exchangeable_book = Book.find(params[:book])
          @exchangeable_book.is_available = 0
          @exchangeable_book.save
          @order.exchangeable_book_id = @exchangeable_book.id
          @order.state = "confirmed"
          @book = Book.find(@order.book_id)
          @book.is_available = 0
          if @order.save
            user = User.find(@order.user_id)
            TasksController.send_notification(user, @current_user ,"#{@current_user.name} accepted to exchange books", "http://localhost:4200/showNotifications")
            render json:{status: 'SUCCESS', message: 'Order to exchange book is confirmed', order: @order}, status: :ok
          end
        end
       end
       def dismiss_exchange
          @order = Order.find(params[:id])
          # @book = Book.find(@order.book_id)
          # @book.save
          if @order.state == "confirmed"
            render json:{status: 'FAIL', message: 'order has already been confirmed'},status: :ok
          elsif @order.destroy!
            user = User.find(@order.user_id)
            TasksController.send_notification(user, @current_user , @current_user.name+ " doesn\'t want to exchange books","http://localhost:4200/showNotifications")
            render json:{status: 'SUCCESS', message: 'Order to exchange is cancelled'},status: :ok
          end
       end
       def showOrders
        @user = User.find(params[:id])
        @order_as_client = @user.orders
        @order_as_seller = Order.where(seller_id: @user.id)
        render json:{status: 'SUCCESS', orders_as_a_client: @order_as_client, orders_as_a_seller: @order_as_seller},status: :ok
       end

      ####  Show order details of a certain book####
      def show 
        @order = Order.find(params[:id])
       render :json => @order, each_serializer: OrderSerializer
      end
      
      # confirm order
      def confirm_order
        # @current_user = AuthorizeApiRequest.call(request.headers).result
        if @current_user
          # check current user is the owner of book
          if (@current_user.id == @order.seller_id)
            #update order state 
            @order.state = "confirmed"
            if (@book.transcation == "Free Share")
              @book.is_available = 0
            end
            if (@order.save && @book.save)
              #send notification to order owner and book owner
              @order_user=User.find(@order.user_id)
              @sender_user=@current_user
              body= "Your order confirmed for #{@book.name} book. You must communicate with the owner"
              click_action= "http://localhost:4200/userprofile/#{@sender_user.id}"
              TasksController.send_notification(@order_user,@sender_user ,body , click_action)
              body= "Your order confirmed for #{@book.name} book. You must communicate with the owner of order"
              click_action= "http://localhost:4200/userprofile/#{@order_user.id}"
              TasksController.send_notification(@sender_user ,"website",body , click_action)
              render json: {status: 'SUCCESS', message: 'Order successfully confirmed', error:@book.errors},status: :ok                                
            else
              render json: {status: 'FAIL', message: 'Order can\'t confirmed, tey again', error:@book.errors},status: :ok                
            end  
          else
            render json: {status: 'FAIL', message: 'Not the owner of this book, so you can\'t dismiss order', error:@book.errors},status: :ok
          end  
        end  
      end  

      # dismiss order
      def dismiss_order
        # @current_user = AuthorizeApiRequest.call(request.headers).result
        if @current_user
          # check current user is the owner of book
          if (@current_user.id == @order.seller_id)
            # update quantity of book
            if (@order.transcation ="Sell")
              @book.quantity = @book.quantity + @order.quantity
            end  
            if @order.destroy
              @book.is_available = 1
              @book.save
              # send notification to order owner
              @order_user=User.find(@order.user_id)
              @sender_user=@current_user
              body= "Your order refused for #{@book.name} book."
              click_action= "http://localhost:4200/books/#{@book.id}"
              TasksController.send_notification(@order_user,@sender_user ,body , click_action)
              render json:{status: 'SUCCESS', message: 'Order successfully deleted'},status: :ok
            else
              render json: {status: 'FAIL', message: 'This order can\'t deleted, try again ', error:@book.errors},status: :ok              
            end  
          else
            render json: {status: 'FAIL', message: 'Not the owner of this book, so you can\'t dismiss order', error:@book.errors},status: :ok
          end  
        end
      end  
       
  ####  Show order details ####
  def showOrder
  @order = Order.find(params[:id])
     render :json => @order, each_serializer: OrderSerializer
    end

    private
    def set_book
      @book = Book.find(params[:book_id])
    end
    def set_order
      @order = Order.find(params[:id])
    end  
     #### Authentication of user ####
        def authenticate_request
            @current_user = AuthorizeApiRequest.call(request.headers).result
            render json: { error: 'Not Authorized' }, status: 401 unless @current_user
        end
  end
end
