class Nemeable
  def correct_name
    raise NotImplementedError
  end
end

class Decorator < Nemeable
  def initialize(nameable)
    super()
    @nameable = nameable
  end

  def correct_name
    @nameable.correct_name
  end
end

class CapitalizeDecorator < Decorator
  def correct_name
    @nameable.correct_name.capitalize
  end
end

class TrimmerDecorator < Decorator
  def correct_name
    @nameable.correct_name.length > 10 ? @nameable.correct_name[0..9].gsub(/\s\w+$/,
                                                                           '...') : @nameable.correct_name.length
  end
end
