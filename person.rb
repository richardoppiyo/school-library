class Person
  def initialize(age, parent_permision: true, name: 'Unknown')
    @id = id
    @age = age
    @name = name
    @parent_permision = parent_permision
  end

  private

  def of_age?
    @age > 18
  end

  public

  def can_use_services?
    of_age? && @parent_permision
  end

  attr_accessor :name, :age
  attr_reader :id
end
