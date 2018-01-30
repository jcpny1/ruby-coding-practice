require 'csv'

# Manipulate a list of Outlook contacts' last names.

class Classifieds::Contacts

  # Load the .csv file of first and last names into a binary tree.
  def initialize
    puts "CONTACTS"
    tree = Classifieds::BinaryTree.new
    ctr = 0
    CSV.foreach("contacts.csv") do |row|
      tree.add(row[1]) if !row[1].nil?
      ctr += 1
    end
    puts Dir.pwd
    puts ctr
    tree.print
  end
end
