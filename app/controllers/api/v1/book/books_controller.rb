module Api::V1::Book

    class Api::V1::Book::BooksController < ApplicationController
        
        before_action :authenticate_request, only: [:recommended_books, :create, :update, :exchange, :destroy , :update_bid]

        #### Show all books and searched books #### 
        def index

            @books_all = Book.where(:is_available => 1).where(:is_approved => 1).all
            if (params[:page]).eql? nil
                current_page=1
            else
                current_page=(params[:page])
            end
            if params[:search]
              @searched_books = Book.where(:is_available => 1).where(:is_approved => 1).search(params[:search]).order("created_at DESC").page params[:page]
                    if @searched_books.count != 0
                    render json: @searched_books,
                    meta: {
                        pagination: {
                        per_page: 5,
                        current_page: current_page.to_i,
                        total_pages: (Book.search(params[:search]).count.to_f/5).ceil,
                        total_objects: Book.search(params[:search]).count
                        }
                    }
                    else
                    render json: {status: 'FAIL', message: 'No result Found'},status: :ok
                    end
        elsif params[:category]
            if Category.exists?(params[:category])
                @books_by_category = Book.where(:is_available => 1).where(:is_approved => 1).where(:category_id => params[:category]).order("created_at DESC").page params[:page]
                if @books_by_category.count != 0
                    render json: @books_by_category,
                    meta: {
                    pagination: {
                        per_page: 5,
                        current_page: current_page.to_i,
                        total_pages: (Book.where(:Category_id => params[:category]).count.to_f/5).ceil,
                        total_objects: Book.where(:Category_id => params[:category]).count
                    }
                    }
                else
                    render json: {status: 'FAIL', message: 'No Books Found in this category'},status: :ok 
                end
            else
                render json: {status: 'FAIL', message: 'Category Not Found'},status: :ok 
            end


        else
              @books = Book.where(:is_approved => 1).where(:is_available => 1).all.order('created_at DESC').page(params[:page]).per(5)
            if @books.count != 0
                render json: @books,
                meta: {
                    pagination: {
                    per_page: 5,
                    current_page: current_page.to_i,
                    total_pages: (@books_all.count.to_f/5).ceil,
                    total_objects:@books_all.count
                    }
                }
            else
                render json: {status: 'FAIL', message: 'No books Available'},status: :ok 
            end
            end
        end

         #### Latest Books in Home Page ####
         def latest_books
            @latest_books = Book.where(:is_approved => 1).where(:is_available => 1).order('created_at Desc').limit(20);
            if(@latest_books.count != 0)
                render json:  @latest_books,
                meta: {
                    status: 'SUCCESS',
                    message: 'Loaded latest_books successfully' 
                },status: :ok
            else
                render json: {status: 'FAIL', message: 'Can\'t Load latest_books'},status: :ok
            end

        end 

        #### Recommended Books in Home Page ####
        def recommended_books
            if @current_user
                @recommended_books ||= []
                user_interests =  @current_user.categories
                if user_interests.count != 0
                    for interest in user_interests
                        @recommended_books << interest.books.where(:is_approved => 1).where(:is_available => 1).order('created_at Desc').limit(5)
                    end
                    render json:  @recommended_books,
                    meta: {
                        status: 'SUCCESS',
                        message: 'Loaded latest_books successfully' 
                    },status: :ok
                else
                    render json: {status: 'FAIL', message: 'user do\'t have interests'},status: :ok 
                end
            end 
        end 
         
        ### Show Book ####
        def show
            if Book.exists?(params[:id])
                @book = Book.find(params[:id])
                render json:  @book,
                    meta: {
                        status: 'SUCCESS',
                        message: 'Book Loaded successfully' 
                    },status: :ok
               # render :json => @book, each_serializer: BookSerializer
            else
                render json: {status: 'FAIL', message: 'Book Not Found'},status: :ok
            end

        end

        #### Create book ####
        def create
            if @current_user
                @user = @current_user
                @book = Book.new(book_params)
                if not book_params[:transcation]
                    @book.transcation = "Sell"
                end
                @book.user_id = @user.id
                if @book.save
                    if params[:book][:book_images_attributes]
                        params[:book][:book_images_attributes].each do |file|
                            @book.book_images.create!(:image => file)
                        end
                    end
             
                    #### send notificatios to users that interest this new book
                    @book_category = @book.category
                    @users_interest_book = @book_category.users

                    @users_interest_book.each do |user|
                        TasksController.send_notification(user ,"website","There is new book available falls under your interests ", "http://localhost:4200/books/#{@book.id}")
                    end
                    
                    render json: {status: 'SUCCESS', message: 'Book successfully created', book:@book},status: :ok
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
                    if params[:book][:book_images_attributes]
                        @bookImages = @book.book_images
                        for bookImg in @bookImages
                            #if bookImg.book_id == @book.id
                            bookImg.destroy
                            #end
                        end
                        params[:book][:book_images_attributes].each do |file| 
                            # @book.book_images.destroy
                            @book.book_images.create!(:image => file)
                       end
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
            puts @current_user.name
            #check if book exist
            if Book.exists?(params[:id])
                @book = Book.find(params[:id])
               # check book transcation
                if @book.transcation.eql? "Sell By Bids"
                    #check if bid quatity is geater than the price of book
                    @user_bid_price=params[:price]
                    if @user_bid_price.to_f >  @book.price.to_f
                        @book.update(:price => @user_bid_price , :bid_user => @current_user.id)
                        render json:  {status: 'SUCCESS', message: 'bid_price added successfully'} , status: :ok
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
