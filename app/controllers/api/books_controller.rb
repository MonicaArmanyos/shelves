module Api
    class Api::BooksController < ApiController

        def index
            @books = Book.all
            if params[:search]
              @books = Book.search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 3) 
               
            else
              @books = Book.all.order('created_at DESC').paginate(page: params[:page], per_page: 3) 
              
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
            @current_user = AuthorizeApiRequest.call(request.headers).result
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
        ### Show Book
        def show
            @book = Book.find(params[:id])
            if(@book)
                render :json => @book, each_serializer: BookSerializer
            else
                render json: {status: 'FAil', message: 'Can\'t Loaded book'},status: :ok
            end

        end
        #### Create book 
        def create
            if current_user
                @user = current_user
                @book = Book.new(book_params)
                @book.user_id = @user.id
                if @book.save
                    params[:book][:book_images_attributes].each do |file|
                        @book.book_images.create!(:image => file)
                    end
                    render json: {status: 'SUCCESS', message: 'Book successfully created', book:@book},status: :ok
                else
                    render json: {status: 'FAIL', message: 'Couldn\'t create book', error:@book.errors},status: :ok
                end
            end
        end

        private
        #### Permitted book params 
        def book_params
            params.require(:book).permit(:name, :description, :transcation, :quantity, 
                                        :bid_user, :category_id, :price, book_images_attributes:[:id, :book_id, :image])
        end

       
    end
end
