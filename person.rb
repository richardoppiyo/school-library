class Person
  def initialize(age, parent_permision: true, name = 'Unknown')
    @id = id
    @age = age
    @name = name
    @parent_permision = parent_permision
  end

  private

  def is_of_age?
    @age > 18
  end

  public

  def can_use_services?
    is_of_age? && @parent_permision
  end

  attr_reader :id, :name, :age
  attr_writer :name, :age
end
