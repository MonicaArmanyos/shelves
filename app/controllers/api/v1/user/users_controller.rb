module Api::V1::User
  class Api::V1::User::UsersController < ApplicationController
      before_action :authenticate_request, only: [:update, :show , :get_user_books]
     
      # POST /signup
      # return authenticated token upon signup
      def create
        @user = User.new(user_params)
        #@user.profile_picture = "/assets/images/default_profile.jpg"
        if @user.save
          UserMailer.registration_confirmation(@user).deliver
        auth_token = AuthenticateUser.new(@user.email, @user.password).call
        response = {status: 'SUCCESS', message: Message.account_created, auth_token: auth_token }
        render json: response, status: :created
      else
        render json: {status: 'FAIL', message: "Email already taken or passwords don\'t match"}, status: :ok
        end
      end

      def confirm_email
          user=User.find_by_confirm_token(params[:id])
          if user
            user.email_activate
            render json: {status: 'SUCCESS', message: "Your account has now been confirmed.You can login now !"}, status: :ok
          else 
            render json: {status: 'FAIL', message: "Something went wrong!"}, status: :notfound
        end
        
       end


       def update
          @user = User.find(params[:id]) 
          if @user == @current_user
            @user.profile_picture = params[:profile_picture]
            begin
               @user.save!
               @user.update(user_complete_params)
                    if params[:phone]
                      
                      newPhones = params[:phone].values
                      @phones = Phone.where(user_id: @user.id )
                      @phones.each do |oldphone|
                        if newPhones.include?(oldphone.phone) == false
                          oldphone.destroy
                        end #end if 
                      end  #end do
                      newPhones.each do |tel|
                        flag=0 #means that new phone not included in old ones 
                        @phones.each do |old|
                        if tel == old.phone
                          flag=1
                        end #end if 
                      end  #end do
                        if flag == 0
                          @phone = Phone.new(user_id: @user.id, phone: tel)
                          @phone.save
                        end #end if
                        end #end do
                      
                      end # end if 
                      if params[:building_number]
                                  b_number = params[:building_number]
                                  st=params[:street]
                                  reg=params[:region]
                                  newCity = params[:city]
                                  code = params[:postal_code]
                                  @addresses= Address.where(user_id: @user.id )
                                  @addresses.each do |oldAddr|
                                    if b_number != (oldAddr.building_number.to_s) || st != (oldAddr.street)  || reg != (oldAddr.region) || newCity != (oldAddr.city) ||  code != (oldAddr.postal_code) 
                                      oldAddr.destroy
                                    end  #end if
                                  end #end do
                                
                                    flag = 0 #flag is 0 if new address is not included in old ones
                                    @addresses.each do |oldAddress|
                                      if b_number == oldAddress.building_number.to_s && st == oldAddress.street && reg == oldAddress.region && newCity == oldAddress.city && code == oldAddress.postal_code.to_s
                                        flag = 1
                                    end #end if 
                                    end #end do 
                                    if flag == 0
                                      @address = Address.new(user_id: @user.id, building_number: b_number, street: st, region: reg, city: newCity, postal_code: code)
                                      @address.save
                                    end 
                                
                       end #end if 
                       @user.categories.each do |userCateg|
                                  if params[userCateg.name] == nil
                                    @user.categories.delete(userCateg)
                                  end
                        end
                        @interests = Category.all
                                @interests.each do |interest|
                                  if params[interest.name]
                                    if @user.categories.include?(interest) == false
                                      @user.categories << interest
                                    end
                                  end
                                end
                        render json: {status: 'SUCCESS', message: "Profile updated", user: @user, phones: @user.phones , addresses: @user.addresses},  :except => [:password_digest], status: :ok
                           
            rescue
              render json: {status: 'FAIL', message: "Failed to update because invalid profile picture has been entered"}, status: :ok
            end
          else
            render json: { error: 'Not Authorized' }, status: 401
          end
        end
      # def update
      #   @user = User.find(params[:id]) 
      #   # @user.profile_picture = params[:profile_picture]
      #   # if @user.save!
      #         @user.update(user_complete_params)
      #         if params[:phone]
                
      #           newPhones = params[:phone].values
                
      #         #   phonesarray = JSON.parse(newPhone)
      #           @phones = Phone.where(user_id: @user.id )
      #           @phones.each do |oldphone|
      #             if newPhones.include?(oldphone.phone) == false
      #               oldphone.destroy
      #             end #end if 
      #           end  #end do
      #           newPhones.each do |tel|
      #             flag=0 #means that new phone not included in old ones 
      #             @phones.each do |old|
      #             if tel == old.phone
      #               flag=1
      #             end #end if 
      #           end  #end do
      #             if flag == 0
      #               @phone = Phone.new(user_id: @user.id, phone: tel)
      #               @phone.save
      #             end #end if
      #             end #end do
                
      #           end # end if 
      #         if params[:building_number]
      #           b_number = params[:building_number]
      #           st=params[:street]
      #           reg=params[:region]
      #           newCity = params[:city]
      #           code = params[:postal_code]
      #           @addresses= Address.where(user_id: @user.id )
      #           @addresses.each do |oldAddr|
      #             if b_number != (oldAddr.building_number.to_s) || st != (oldAddr.street)  || reg != (oldAddr.region) || newCity != (oldAddr.city) ||  code != (oldAddr.postal_code) 
      #               oldAddr.destroy
      #             end  #end if
      #           end #end do
              
      #             flag = 0 #flag is 0 if new address is not included in old ones
      #             @addresses.each do |oldAddress|
      #               if b_number == oldAddress.building_number.to_s && st == oldAddress.street && reg == oldAddress.region && newCity == oldAddress.city && code == oldAddress.postal_code.to_s
      #                 flag = 1
      #             end #end if 
      #             end #end do 
      #             if flag == 0
      #               @address = Address.new(user_id: @user.id, building_number: b_number, street: st, region: reg, city: newCity, postal_code: code)
      #               @address.save
      #             end 
              
      #         end #end if 
      #         @user.categories.each do |userCateg|
      #           if params[userCateg.name] == nil
      #             @user.categories.delete(userCateg)
      #           end
      #         end
      #         @interests = Category.all
      #         @interests.each do |interest|
      #           if params[interest.name]
      #             if @user.categories.include?(interest) == false
      #               @user.categories << interest
      #             end
      #           end
      #         end
      #         render json: {status: 'SUCCESS', message: "Profile updated", user: @user, phones: @user.phones , addresses: @user.addresses},  :except => [:password_digest], status: :ok
      #   
      # else
      #   #   render json: {status: 'FAIL', message: "Failed to update because invalid profile picture has been entered"}, status: :ok
      #   # end
      # end #end method

      def destroy
      end

      #### get current user info
      def show
        @user = @current_user
        @books = Book.all
        @user_books = Array.new
        for book in @books
            if book.user_id == @current_user.id 
              @user_books << book
            end
        end
        render json: {status: 'SUCCESS', :user => @user, books: @user_books,  auth_token: request.headers['Authorization'], phones: @user.phones, addresses: @user.addresses}, :except => [:password_digest],status: :ok
      end
      #### get user books ####
      def get_user_books
        if  User.exists?(:id => params[:id])
            @user_books= Book.where(:user_id => params[:id])
            render :json => @user_books, each_serializer: BookSerializer
            #render json: {status: 'SUCCESS', message: 'Loaded notification_messages successfully', notification_messages:@notification_messages},status: :ok
        else
            render json: {status: 'FAIL', message: 'user not found'},status: :ok
        end
      end

      #### get all book_stores ####
      def get_all_book_stores
        @book_stores=User.where(:role => 1)
        if @book_stores.count != 0
          render json: {status: 'SUCCESS', :book_stores => @book_stores.select(User.column_names - ["gender","password_digest","email_confirmed","confirm_token","created_at","updated_at","password_reset_token","password_reset_sent_at"])},status: :ok
        else
          render json: {status: 'FAIL', message: 'No book_stores found'},status: :ok
        end
      end
      
      #### get cities ###
      def getCities
        @cities = City.all
        render json: {status: 'SUCCESS',cities: @cities},status: :ok
      end
      
      private
      #### Authentication of user ####
      def authenticate_request
          @current_user = AuthorizeApiRequest.call(request.headers).result
          render json: { error: 'Not Authorized' }, status: 401 unless @current_user
      end
      
      def user_params
        params.permit(
          :name,
          :email,
          :password,
          :password_confirmation, 
          :role
        )
    end
    def user_complete_params
      params.permit(
        :id,
        :name,
        :email, 
        :profile_picture,
        :gender,
        # :building_number,
        # :street,
        # :region,
        # :city,
        # phone: []
      )
    end


  end
end
