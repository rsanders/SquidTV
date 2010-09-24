class MediaScanner

  def self.singleton
    @singleton ||= MediaScanner.new
  end

  def raze_and_build(roots = nil)
    roots ||= MediaRoot.active

    Phile.transaction do
      Episode.delete_all
      Show.delete_all

      Movie.delete_all
      
      Phile.delete_all

      roots.each do |root|
        Phile.list_all(root).map &:save!
      end

    end
  end

end
