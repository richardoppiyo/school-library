require './person'

class Student < Person
  attr_accessor :classroom

  def initialize(age, name, classroom, parent_permission: true)
    super(age, name, parent_permission)
    @classrooms = classroom
  end

  def play_hooky
    "¯\(ツ)/¯"
  end

  def classrooms
    @classroom = classroom
    classroom.student.push(self) unless classroom.student.include?(self)
  end
end
