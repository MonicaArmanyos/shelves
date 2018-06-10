module Api::V1::Book

    class Api::V1::Book::BooksController < ApplicationController
        
        before_action :authenticate_request, only: [:recommended_books, :create, :update, :exchange, :destroy]

        #### Show all books and searched books #### 
        def index
            @books_all = Book.all
            if params[:search]
              @searched_books = Book.search(params[:search]).order("created_at DESC").page params[:page]
              render json: @searched_books,
              meta: {
                pagination: {
                  per_page: 5,
                  total_pages: Book.search(params[:search]).count/5,
                  total_objects: Book.search(params[:search]).count
                }
              }
            else
              @books = Book.all.order('created_at DESC').page(params[:page]).per(5)
              render json: @books,
              meta: {
                pagination: {
                  per_page: 5,
                  total_pages: @books_all.count/5,
                  total_objects:@books_all.count
                }
              }
            end
        end

         #### Latest Books in Home Page ####
         def latest_books
            @latest_books = Book.order('created_at Desc').limit(20);
            if(@latest_books)
                render :json => @latest_books, each_serializer: BookSerializer
            else
                render json: {status: 'FAil', message: 'Can\'t Loaded latest_books'},status: :ok
            end

        end 

        #### Recommended Books in Home Page ####
        def recommended_books
            if @current_user
                
                @recommended_books ||= []
                user_interests =  @current_user.categories
                for interest in user_interests
                    @recommended_books << interest.books.order('created_at Desc').limit(5)
                end
               
                #render json: {status: 'SUCCESS', message: 'Loaded recommended_books', data:@recommended_books},status: :ok
                render :json => @recommended_books
            end 
        end 
         
        ### Show Book ####
        def show
            @book = Book.find(params[:id])
            if(@book)
                render :json => @book, each_serializer: BookSerializer
            else
                render json: {status: 'FAil', message: 'Can\'t Loaded book'},status: :ok
            end

        end

        #### Create book ####
        def create
            if @current_user
                @user = @current_user
                @book = Book.new(book_params)
                @book.user_id = @user.id
               
              
                if @book.save
                    params[:book][:book_images_attributes].each do |file|
                        @book.book_images.create!(:image => file)
                    end
                    render json: {status: 'SUCCESS', message: 'Book successfully created', book:@book},status: :ok
                    send_notification(@user ,"Book successfully created", "https://angularfirebase.com")
                else
                    render json: {status: 'FAIL', message: 'Couldn\'t create book', error:@book.errors},status: :ok
                end
            end
        end

        #### Update Book ####
        def update
            @book = Book.find(params[:id])
            if @current_user.id == @book.user_id
               if @book.update(book_params)
                   params[:book][:book_images_attributes].each do |file|
                       @book.book_images.uodate!(:image => file)
                   end
                   render json: {status: 'SUCCESS', message: 'Book successfully updated', book:@book},status: :ok
               else
                   render json: {status: 'FAIL', message: 'Couldn\'t update book', error:@book.errors},status: :ok
               end 
           else
               render json: {status: 'FAIL', message: 'Un authorized', error:@book.errors},status: :ok
           end
           end 

         
          

        #### Delete Book ####
        def destroy
           
            if Book.exists?(params[:id])
                @book = Book.find(params[:id])
                @book.destroy
                render json: {status: 'SUCCESS', message: 'Book successfully deleted'},status: :ok
            else
                render json: {status: 'FAIL', message: 'Couldn\'t delete book,Book Not found'},status: :ok
            end

        end

        ########################## Book orders ############################

        #### Order Book For Exchange ####
        def exchange
            @wanted_book =  Book.find(params[:id])
            if @wanted_book.transcation == "Exchange"
            @books = Book.all
            @exchangeable_books = Array.new
            
            for book in @books
                if book.user_id == @current_user.id  && book.transcation == "Exchange"
                    @exchangeable_books << book
                end
            end
            @order = Order.new(user_id: @current_user.id, book_id: @wanted_book.id, seller_id: @wanted_book.user_id, state: "under confirmed", transcation: "Exchange")
            @order.save
            render json:  {status: 'SUCCESS', exchangeable_books: @exchangeable_books, wanted_book: @wanted_book, order: @order}, :include => { :user  =>  {:except => :password_digest} } , status: :ok
            else
                render json:  {status: 'FAIL', message: "Book not for exchange"}, status: :ok
        end
        end

        #### Update bid quantity and bid user for book ####
        def update_bid
            #check if book exist
            if Book.exists?(params[:id])
               # check book transcation
                if @book.transcation.eql? "Sell By Bids"
                    #check if bid quatity is geater than the price of book
                    @user_bid_price=params[:price]
                    if @user_bid_price >  @book.price

                    else
                        render json: {status: 'FAIL', message: 'bid_price not valid'},status: :ok
                    end
                else
                    render json: {status: 'FAIL', message: 'Book Not for sell by bids'},status: :ok
                end
            else
                render json: {status: 'FAIL', message: 'Book Not found'},status: :ok
            end

           
        end

       
        private
        #### Permitted book params ####
        def book_params
            params.require(:book).permit(:name, :description, :transcation, :quantity, 
                                        :bid_user, :category_id, :price, book_images_attributes:[:id, :book_id, :image])
        end

        #### Authentication of user ####
        def authenticate_request
            @current_user = AuthorizeApiRequest.call(request.headers).result
            render json: { error: 'Not Authorized' }, status: 401 unless @current_user
        end

        

       
    end

end
