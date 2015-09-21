task :Schedule =>:environment do
    puts "=======================   Update Coupons   ======================="

    @start_date = Date.today.send(:-, 1.day)
    puts @start_date
    @today_date = Date.today
    puts @today_date

    @orders   = ShopifyAPI::Order.find(:all, :params => {:limit => 250,:created_at_min => @start_date ,:created_at_max => @today_date ,:order => "created_at DESC" })
                              
    puts"================================================"
  
end  # end of environment
