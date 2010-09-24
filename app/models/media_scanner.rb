class MediaScanner

  attr_accessor :roots

  def self.singleton
    @singleton ||= MediaScanner.new
    @singleton.reload_roots
    @singleton
  end

  def initialize(roots = nil)
    self.roots = roots || MediaRoot.active
  end

  def reload_roots
    self.roots = MediaRoot.active
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

  def update_file(path)
    raise "Unimplemented"
  end

  def restart_monitor
    # @monitor && @monitor.
    reload_roots
#    roots = self.roots
#    @monitor = FSSM.monitor do
#      roots.each do |root|
#        path root.path do
#          glob '**/*'
#
#          update {|base, relative| puts "update from root-#{root.id} in #{base} to #{relative}" }
#          delete {|base, relative| puts "delete from root-#{root.id} in #{base} to #{relative}" }
#          create {|base, relative| puts "create from root-#{root.id} in #{base} to #{relative}" }
#        end
#      end
#    end
  end

end
