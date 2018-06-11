namespace :books do
    desc "Rake task to check if duration of sell by bids is finished "
  task :check_bid_duration => :environment do
   @books_for_bids=Book.where(:transcation => 3).where(:is_available => 1)
   
    for book_for_bid in @books_for_bids
      if ! book_for_bid.bid_duration.eql? nil
        @bid_date = book_for_bid.bid_duration.to_date 
        @today=Date.today
        if @bid_date <= @today
          #### create new order in database ####
           
        else
          puts "bid_duration still working"
        end
    end
    end
  end
end
