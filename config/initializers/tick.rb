
Thread.new do 
  while true
    sleep 30
    Rails.logger.info "Scan tick at #{Time.now}"
    MediaScanner.singleton.tick
  end
    
end