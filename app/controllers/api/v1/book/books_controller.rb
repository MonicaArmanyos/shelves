module Api::V1::Book

    class Api::V1::Book::BooksController < ApplicationController
        
        before_action :authenticate_request, only: [:recommended_books, :create, :update, :exchange, :destroy]
        
        #### Show all books and searched books #### 
        def index
            @books = Book.all
            if params[:search]
              @books = Book.search(params[:search]).order("created_at DESC").page params[:page]
               
            else
              @books = Book.all.order('created_at DESC').page params[:page]
              
            end
            render :json => @books, each_serializer: BookSerializer
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
                @user_notification_tokens = @user.notification_tokens
                
                @user_img_url=@serverurl+@user.profile_picture.url
              
                if @book.save
                    params[:book][:book_images_attributes].each do |file|
                        @book.book_images.create!(:image => file)
                    end
                    render json: {status: 'SUCCESS', message: 'Book successfully created', book:@book},status: :ok
                    send_notification(@user_notification_tokens ,"Book successfully created" ,@user_img_url, "https://angularfirebase.com")
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
               render json: {status: 'FAIL', message: 'Un autherized', error:@book.errors},status: :ok
           end
           end 

           #### Order Book For Exchange ####
           def exchange
              @wanted_book =  Book.find(params[:id])
              @books = Book.all
              @exchangeable_books = Array.new
            
               for book in @books
                   if book.user_id == @current_user.id  && book.transcation == "Exchange"
                       @exchangeable_books << book
                   end
              end
              render json:  {status: 'SUCCESS', exchangeable_books: @exchangeable_books}, status: :ok
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
