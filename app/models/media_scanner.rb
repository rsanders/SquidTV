class MediaScanner

  attr_accessor :roots

  def self.singleton
    @singleton ||= MediaScanner.new
  end

  def initialize(roots = nil)
    self.roots = roots || MediaRoot.active
  end

  def raze_and_build
    Phile.transaction do
      Phile.destroy_all

      roots.each do |root|
        root.scan
      end

    end
  end

  def tick
    Phile.transaction do
      roots.each do |root|
        root.scan_if_scheduled
      end
    end


  end

end
