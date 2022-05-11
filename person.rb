require './decorator'

class Person < Nemeable
  attr_accessor :name, :age, :id, :parent_permission

  def initialize(age, parent_permision: true, name: 'maximilianus', id: Random.rand(1..1000))
    super()
    @id = id
    @age = age
    @name = name
    @parent_permision = parent_permision
  end

  def can_use_services?
    of_age? && @parent_permision
  end

  def correct_name
    @name
  end

  private

  def of_age?
    @age > 18
  end
end

person = Person.new(22)
puts person.correct_name

capitalized_person = CapitalizeDecorator.new(person)
puts capitalized_person.correct_name

capitalized_trimmed_person = TrimmerDecorator.new(capitalized_person)
puts capitalized_trimmed_person.correct_name
