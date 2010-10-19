module Groupify
  class << self
    def sort_date(object)
      [:aired_at, :first_aired_at, :file_created_at, :file_modified_at, :created_at, :modified_at].each do |method|
        return object.send(method) if object.respond_to?(method) && object.send(method)
      end
      nil
    end

    def sort_name(object)
      case object
        when Show then object.name
        when Episode then object.show.name
        when Phile then object.filename
        else object.to_s
      end
    end

    def groupify(objects, dateproc = nil)
      if ! dateproc
        dateproc = Proc.new {|f| Groupify.sort_date(f) }
      end
      bars =
              [Time.now, 1.day.ago, 2.days.ago, 3.days.ago, 1.week.ago, 2.weeks.ago, 3.weeks.ago, 1.month.ago, 2.months.ago,
               3.months.ago, 4.months.ago, 6.months.ago, 1.year.ago]
      groups = []
      (0..bars.size-2).each do |idx|
        high = bars[idx]
        low = bars[idx+1]
        groups << [low, objects.select {|file| dateproc.call(file) >= low and dateproc.call(file) < high}.
                         sort {|a,b| Groupify.sort_name(a) <=> Groupify.sort_name(b) }
        ]
      end
      groups.reject {|pair| pair[1].size == 0}
    end
  end
end