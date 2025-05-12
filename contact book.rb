require 'csv'

class Contact
  attr_accessor :name, :phone, :email

  def initialize(name, phone, email)
    @name = name
    @phone = phone
    @email = email
  end

  def to_csv
    [name, phone, email]
  end
end

class ContactBook
  FILE_NAME = 'contacts.csv'

  def initialize
    create_file_if_missing
  end

  def create_file_if_missing
    unless File.exist?(FILE_NAME)
      CSV.open(FILE_NAME, 'w') { |csv| csv << %w[Name Phone Email] }
    end
  end

  def add_contact
    print "Enter name: "
    name = gets.chomp
    print "Enter phone: "
    phone = gets.chomp
    print "Enter email: "
    email = gets.chomp

    contact = Contact.new(name, phone, email)
    CSV.open(FILE_NAME, 'a') { |csv| csv << contact.to_csv }

    puts "Contact added successfully!"
  end

  def list_contacts
    puts "\nAll Contacts:"
    CSV.foreach(FILE_NAME, headers: true).with_index do |row, i|
      puts "#{i + 1}. #{row['Name']} | #{row['Phone']} | #{row['Email']}"
    end
  end

  def search_contact
    print "Enter name or phone to search: "
    query = gets.chomp.downcase
    found = false

    CSV.foreach(FILE_NAME, headers: true).with_index do |row, i|
      if row['Name'].downcase.include?(query) || row['Phone'].include?(query)
        puts "Found: #{row['Name']} | #{row['Phone']} | #{row['Email']}"
        found = true
      end
    end

    puts "No contact found." unless found
  end

  def delete_contact
    list_contacts
    print "Enter contact number to delete: "
    number = gets.chomp.to_i

    contacts = CSV.table(FILE_NAME)
    if number >= 1 && number <= contacts.size
      contacts.delete(number - 1)
      File.open(FILE_NAME, 'w') { |f| f.write(contacts.to_csv) }
      puts "Contact deleted."
    else
      puts "Invalid number."
    end
  end

  def update_contact
    list_contacts
    print "Enter contact number to update: "
    number = gets.chomp.to_i

    contacts = CSV.table(FILE_NAME)
    if number >= 1 && number <= contacts.size
      contact = contacts[number - 1]
      print "New name (#{contact[:name]}): "
      contact[:name] = gets.chomp.strip
      print "New phone (#{contact[:phone]}): "
      contact[:phone] = gets.chomp.strip
      print "New email (#{contact[:email]}): "
      contact[:email] = gets.chomp.strip

      File.open(FILE_NAME, 'w') { |f| f.write(contacts.to_csv) }
      puts "Contact updated."
    else
      puts "Invalid number."
    end
  end
end

# Main menu
book = ContactBook.new

loop do
  puts "\n--- Contact Book ---"
  puts "1. Add Contact"
  puts "2. View Contacts"
  puts "3. Search Contact"
  puts "4. Update Contact"
  puts "5. Delete Contact"
  puts "6. Exit"
  print "Choose an option: "
  choice = gets.chomp.to_i

  case choice
  when 1 then book.add_contact
  when 2 then book.list_contacts
  when 3 then book.search_contact
  when 4 then book.update_contact
  when 5 then book.delete_contact
  when 6 then break
  else
    puts "Invalid option."
  end
end
