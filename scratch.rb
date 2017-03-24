
def my_method(settings = {})
  puts "Clear it with Sidney" unless settings[:rosebud] == false
end

puts "---"
my_method(rosebud: false)

puts "---"
my_method

puts "---"
my_method(rosebud: true)
