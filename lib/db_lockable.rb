module DBLockable

  #
  # TODO: should use locking columns if available
  #
  def with_lock(&block)
    self.class.transaction do
      self.lock!
      block.call
    end
  end

end
