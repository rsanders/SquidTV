class MainController < ApplicationController
  def index
    Phile.root = APP_CONFIG[:roots]["tv"]
    @files = Phile.list_all.reject {|file| file.modified_at < 6.months.ago}
    @bars =
            [Time.now, 1.day.ago, 2.days.ago, 3.days.ago, 1.week.ago, 2.weeks.ago, 3.weeks.ago, 1.month.ago, 2.months.ago,
             3.months.ago, 4.months.ago, 6.months.ago, 1.year.ago]
    @groups = []
    (0..@bars.size-2).each do |idx|
      high = @bars[idx]
      low = @bars[idx+1]
      logger.debug "selecting #{low} <= file <= #{high}"
      @groups << [low, @files.select {|file| file.modified_at >= low and file.modified_at < high}]
    end
    @groups.reject! {|pair| pair[1].size == 0}
    logger.debug @groups.inspect
  end

end
