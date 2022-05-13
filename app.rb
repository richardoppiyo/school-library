#!/usr/bin/env ruby

require './student'
require './teacher'
require './book'
require './rental'

class App
  def initialize
    @books = []
    @person = []
    @rentals = []
  end

  def select_opt
    option = gets.chomp.to_i
    case option
    when 1 then list_books
    when 2 then list_people
    when 3 then create_person
    when 4 then create_book
    when 5 then create_rental
    when 6 then list_rentals
    else
      puts 'Invalid number, please try again!'
    end
  end

  def list_books
    @books.each do |book|
      puts "Title: #{book.title}, Author: #{book.author}"
    end
  end

  def list_people
    @person.each do |pers|
      puts "[#{pers.class}] Name: #{pers.name}, ID: #{pers.id}, Age: #{pers.age}"
    end
  end

  def create_book
    print 'Title:'
    title = gets.chomp

    print 'author:'
    author = gets.chomp

    @books.push(Book.new(title, author))

    puts 'Book created successfully'
  end

  def check_number(msg)
    number = 0
    loop do
      print msg
      input = gets.chomp.to_i
      if input.is_a?(Integer) && input.positive?
        number = input
        break
      else
        puts 'Please, enter a valid input!'
      end
    end
    number
  end

  def check_options(msg, options)
    number = 0
    loop do
      print msg
      input = gets.chomp.to_i
      if options.include?(input)
        number = input
        break
      else
        puts 'Please, enter a valid input!'
      end
    end
    number
  end

  def create_person
    num = check_options('Do you want to create a student (1) or a teacher (2)? [input the number]: ', [1, 2])
    age = check_number('Age:')
    name = gets.chomp
    case num
    when 1
      print 'Has parent permission? [y/n]:'
      parent_permission = gets.chomp
      case parent_permission
      when 'y' then parent_permission = true
      when 'n' then parent_permission = false
      end
      @person.push(Student.new(age, name, parent_permission: parent_permission))
    when 2
      print 'Specialization:'
      specialization = gets.chomp
      @person.push(Teacher.new(age, specialization, name))
    else
      puts 'Invalid number, please enter number again!'
    end
    puts 'Person created successfully'
  end

  def create_rental
    puts 'Select a book from the following list'
    @books.each_with_index do |book, index|
      puts "#{index + 1}) Title: #{book.title}, Author: #{book.author}"
    end
    book_num = gets.chomp.to_i

    puts 'Select a person from the following list'
    @person.each_with_index do |per, index|
      puts "No: #{index + 1}, [#{per.class}] Name: #{per.name}, ID: #{per.id}, Age: #{per.age}"
    end
    person_num = gets.chomp.to_i

    print 'Date:'
    date = gets.chomp

    @rentals.push(Rental.new(date, @person[person_num - 1], @books[book_num - 1]))
    puts 'Rental Created successfully'
  end

  def list_rentals
    print 'Kindly enter the ID of the person:'
    id_person = gets.chomp
    id_person = id_person.to_i

    puts 'Rentals'
    @rentals.each do |rental|
      puts "Date: #{rental.date} Book: #{rental.book.title} by #{rental.book.author}" if rental.person.id == id_person
    end
  end
end
