namespace :books do
  
    desc "Rake task to check if duration of sell by bids is finished "
  task :check_bid_duration => :environment do
   @books_for_bids=Book.where(:transcation => 3).where(:is_available => 1).where(:bid_duration_state => 0)
   
    for book_for_bid in @books_for_bids
      if ! book_for_bid.bid_duration.eql? nil
        @bid_date = book_for_bid.bid_duration.to_date 
        @today=Date.today
        if @bid_date <= @today
          #### create new order in database ####
          @order = book_for_bid.orders.new(:book_id => book_for_bid.id, :user_id => book_for_bid.bid_user, :state => 0, :seller_id => book_for_bid.user_id, :transcation => book_for_bid.transcation, :price => book_for_bid.price)
          if @order.save
           
            @seller_user=User.find(book_for_bid.user_id)
            @bid_user=User.find(book_for_bid.bid_user)
            body= "Bid duration is ended for #{book_for_bid.name} book."
            TasksController.send_notification(@seller_user ,body, "https://angularfirebase.com")
            TasksController.send_notification(@bid_user,"Congurations ,You Win bid for #{book_for_bid.name} book, Please wait for confirmation from the owner of book","https://angularfirebase.com")
            book_for_bid.update(:bid_duration_state => 1)
            
          else
            puts "Fail"
          end

        else
          puts "bid_duration still working"
        end
    end
    end
  end
end
