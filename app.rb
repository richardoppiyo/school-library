#!/usr/bin/env ruby
require_relative './student'
require_relative './teacher'
require_relative './book'
require_relative './rental'
require_relative './checks'
require 'json'

class App
  include Checks

  def initialize
    @books = load_books
    @person = load_persons
    @rentals = load_rentals
  end

  def select_opt
    option = check_options('', (1..9))
    case option
    when 1 then list_books
    when 2 then list_people
    when 3 then create_person
    when 4 then create_book
    when 5 then create_rental
    when 6 then list_rentals
    when 7
      write_json
      7
    else
      puts 'Invalid number, please try again!'
    end
  end

  def create_person
    num = check_options('Do you want to create a student (1) or a teacher (2)? [input the number]: ', [1, 2])

    age = check_number('Age:')

    print 'Name:'
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
    puts 'Person created successfully 🎉🎉'
  end

  def list_people
    @person.each do |per|
      puts "[#{per.class}] Name: #{per.name}, ID: #{per.id}, Age: #{per.age}"
    end
  end

  def list_books
    @books.each do |book|
      puts "Title: #{book.title}, Author: #{book.author}"
    end
  end

  def create_book
    print 'Title:'
    title = gets.chomp

    print 'author:'
    author = gets.chomp

    @books.push(Book.new(title, author))

    puts 'Book created successfully 🎉🎉 '
  end

  def create_rental
    puts 'Select a book from the following list by number '
    @books.each_with_index do |book, index|
      puts "#{index + 1}) Title: #{book.title}, Author: #{book.author}"
    end
    book_num = check_options('', (1..@books.length + 1))

    puts 'Select a person from the following list by number (not id)'
    @person.each_with_index do |per, index|
      puts "No: #{index + 1}, [#{per.class}] Name: #{per.name}, ID: #{per.id}, Age: #{per.age}"
    end
    person_num = check_options('', (1..@person.length + 1))

    print 'Date:'
    date = gets.chomp

    @rentals.push(Rental.new(date, @person[person_num - 1], @books[book_num - 1]))
    puts 'Rental Created successfully 🎉🎉 '
  end

  def list_rentals
    print 'Id of person:'
    id_person = gets.chomp
    id_person = id_person.to_i

    puts 'Rentals'
    @rentals.each do |rental|
      puts "Date: #{rental.date} Book: #{rental.book.title} by #{rental.book.author}" if rental.person.id == id_person
    end
  end

  def write_json
    persons = @person.each_with_index.map do |person, index|
      { class: person.class, age: person.age, name: person.name,
        specialization: (person.specialization if person.instance_of?(Teacher)),
        parent_permission: person.parent_permission, index: index, id: person.id }
    end

    json_person = JSON.generate(persons)
    File.write('person.json', json_person)

    books = @books.each_with_index.map do |book, index|
      {
        title: book.title, author: book.author, index: index
      }
    end
    json_books = JSON.generate(books)
    File.write('books.json', json_books)

    rentals = @rentals.each_with_index.map do |rental, _index|
      {
        date: rental.date, book_index: @books.index(rental.book),
        person_index: @person.index(rental.person)
      }
    end

    json_rentals = JSON.generate(rentals)
    File.write('rentals.json', json_rentals)
  end

  def load_persons
    return [] unless File.exist?('person.json')

    file = File.open('person.json')
    persons_read = File.read(file)
    persons_json = JSON.parse(persons_read)
    loaded_persons = []
    persons_json.each do |person|
      case person['class']
      when 'Teacher'
        loaded_persons << Teacher.new(person['age'], person['specialization'], person['name'], id: person['id'])
      when 'Student'
        loaded_persons << Student.new(person['age'], person['name'], parent_permission: person['parent_permission'],
                                                                     id: person['id'])
      end
    end
    file.close
    loaded_persons
  end

  def load_books
    return [] unless File.exist?('books.json')

    file = File.open('books.json')
    books_read = File.read(file)
    books_json = JSON.parse(books_read)
    loaded_books = []

    books_json.each do |book|
      loaded_books << Book.new(book['title'], book['author'])
    end
    file.close
    loaded_books
  end

  def load_rentals
    return [] unless File.exist?('rentals.json')

    file = File.open('rentals.json')
    rentals_read = File.read(file)
    rentals_json = JSON.parse(rentals_read)
    loaded_rentals = []

    rentals_json.each do |rental|
      loaded_rentals << Rental.new(rental['date'], @person[rental['person_index']], @books[rental['book_index']])
    end
    file.close
    loaded_rentals
  end
end