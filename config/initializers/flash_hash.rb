# frozen_string_literal: true

module FlashExtensions
  def danger
    self[:danger]
  end

  def danger=(value)
    self[:danger] = value
  end

  def success
    self[:success]
  end

  def success=(value)
    self[:success] = value
  end

  def warning
    self[:warning]
  end

  def warning=(value)
    self[:warning] = value
  end

  def info
    self[:info]
  end

  def info=(value)
    self[:info] = value
  end
end

class ActionDispatch::Flash::FlashHash
  include FlashExtensions
end

class ActionDispatch::Flash::FlashNow
  include FlashExtensions
end
