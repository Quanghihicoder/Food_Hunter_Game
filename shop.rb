
require 'rubygems'
require 'gosu'

SCREEN_HEIGHT, SCREEN_WIDTH = 800, 1000

module ZOrder
  BACKGROUND, FOOD, PLAYER, UI = *0..3
end

class Product
  attr_accessor :type, :items
  def initialize(type, items)
    @type = type
    @items = items
  end
end

class Item
  attr_accessor :name, :state, :image, :small_image
  def initialize(name,state,image,small_image)
    @name = name
    @state = state
    @image = image
    @small_image = small_image
  end
end

def add_money(record)
  file = File.open("money.txt", "a+")
  file.puts(record)
  file.close
end

def minus_money
  sum = sum_file
  if sum > 100
    return true
  else
    return false
  end
end

def sum_file
  sum = 0 
  file = File.open("money.txt", 'r')
  file.each do |line|
    sum += line.to_i
  end
  file.close
  return sum.to_i
end

def draw_money(size)
  sum = sum_file
  size.draw_text("$#{sum}", 800, 20, ZOrder::UI, 2.0, 2.0, Gosu::Color::YELLOW)
end

def load_item product_file
  name = product_file.gets().chomp
  state = product_file.gets().chomp.to_i
  image = product_file.gets().chomp
  small_image = product_file.gets()
  item = Item.new(name, state, image, small_image)
  return item
end


def load_items product_file
  items = Array.new()
  count = product_file.gets().to_i()
  index = 0
  while index < count
    items << load_item(product_file)
    index += 1
  end
  return items
end 

def load_product product_file
  item_type = product_file.gets

  items = load_items(product_file)

  product = Product.new(item_type, items)

  return product
end


def load_products product_file
  products = Array.new
  count = product_file.gets().to_i
  index = 0
  while index < count
    products << load_product(product_file)
    index += 1
  end
  return products
end

def read_information_of_item(type,i)
  name = type.items[i].name.chomp
  state = type.items[i].state
  image = type.items[i].image.chomp
  return name,state,image
end

def mouse_over_button(mouse_x,mouse_y,x,y)
  if mouse_x > x-10 && mouse_x < x+90
    if mouse_y > y+120 && mouse_y < y + 170 
      return true
    end
  else
    return false
  end
end

def find_selected
  File.open('product.txt', 'r+') do |file| 
    lines = file.each_line.to_a
    selected = lines.each_index.select{|i| lines[i] == "0\n"}
    return selected
  end
end

def collect
  product_selected = Array.new()
  selected = find_selected()
  find1 = selected[0]
  find2 = selected[1]
  find3 = selected[2]
  find4 = selected[3]
  find5 = selected[4]
  File.open('product.txt', 'r+') do |file| 
    lines = file.each_line.to_a
    product_selected << lines[find1+1]
    product_selected << lines[find1+2]
    product_selected << lines[find2+1]
    product_selected << lines[find2+2]
    product_selected << lines[find3+1]
    product_selected << lines[find3+2]
    product_selected << lines[find4+1]
    product_selected << lines[find4+2]
    product_selected << lines[find5+1]
    product_selected << lines[find5+2]
    return product_selected
  end
end

def draw_image(x,y,type,i,size1,size2,size_string)
  name, state, image = read_information_of_item(type,i)
  ima = Gosu::Image.new(image)
  ima.draw(x,y, ZOrder::FOOD, size1, size2)
  size_string.draw_text(name,x+7,y+100,ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  if state.to_i == 0
    Gosu.draw_rect(x-10, y+120, 100, 50, Gosu::Color::GREEN, ZOrder::UI, mode=:default)
    size_string.draw_text("Used",x+10,y+135,ZOrder::UI, 1.5, 1.5, Gosu::Color::WHITE)
  end
  if state.to_i == 1
    Gosu.draw_rect(x-10, y+120, 100, 50, Gosu::Color::WHITE, ZOrder::UI, mode=:default)
    size_string.draw_text("Use",x+13,y+135,ZOrder::UI, 1.5, 1.5, Gosu::Color::BLACK)
  end
  if state.to_i == 2
    Gosu.draw_rect(x-10, y+120, 100, 50, Gosu::Color::GRAY, ZOrder::UI, mode=:default)
    size_string.draw_text("$100",x+10,y+135,ZOrder::UI, 1.5, 1.5, Gosu::Color::YELLOW)
  end
  button = mouse_over_button(mouse_x,mouse_y,x,y)
  return button,i,state
end

class Shop < Gosu::Window
    def initialize
        super SCREEN_WIDTH, SCREEN_HEIGHT
        @background = Gosu::Image.new("media/space.png")
        @font = Gosu::Font.new(20)
        self.caption = "Food Hunter Game"
        product_file = File.new("product.txt", "r")
        @products = load_products(product_file)
        @food = @products[0]
        @hunter = @products[1]
    end


    def draw
        @background.draw(0,0, ZOrder::BACKGROUND)
        draw_money(@font)
        check_if()
        #puts ("#{mouse_x} ; #{mouse_y}")
        @button1, @i1, @state1 = draw_image(120,140,@food, 0,1.0,1.0,@font)
        @button2, @i2, @state2 = draw_image(320,140,@food, 1,1.0,1.0,@font)
        @button3, @i3, @state3 = draw_image(600,140,@food, 2,1.0,0.7,@font)
        @button4, @i4, @state4 = draw_image(800,140,@food, 3,1.0,0.7,@font)
        @button5, @i5, @state5 = draw_image(120,340,@food, 4,1.0,1.0,@font)
        @button6, @i6, @state6 = draw_image(320,340,@food, 5,1.0,1.0,@font)
        @button7, @i7, @state7 = draw_image(600,340,@food, 6,1.0,1.0,@font)
        @button8, @i8, @state8 = draw_image(800,340,@food, 7,1.0,1.0,@font)
        @button9, @i9, @state9 = draw_image(220,540,@hunter, 0,0.5,0.5,@font)
        @button10, @i10, @state10 = draw_image(470,540,@hunter, 1,0.5,0.5,@font)
        @button11, @i11, @state11 = draw_image(710,540,@hunter, 2,0.5,0.5,@font)
    end

    def check_if
      i = 4
      y = 38
      count_hunter = Array.new()
      count_food = Array.new()
      File.open('product.txt', 'r+') do |file|
        lines = file.each_line.to_a
        while i <= 32
          count_food << lines[i]
          i += 4
        end
        while y <= 46
          count_hunter << lines[y]
          y += 4
        end
      end
      if count_food.count("0\n") == 4
        @check = true #cannot click more

      elsif count_food.count("0\n") < 4
        @check = false #can click more

      end
      if count_hunter.count("0\n") == 1
        @check1 = true #cannot click more

      elsif count_hunter.count("0\n") < 1
        @check1 = false #can click more

      end
    end
    
    # $product_selected = collect()
    



    def change_button(button,type,i,location)
      if button == true and type.items[i].state == 0 and (@check == true or @check1 == true)
        change_information(1,location)
        type.items[i].state = 1
      elsif button == true and type.items[i].state == 1 and (@check == false or @check1 == false)
        change_information(0,location)
        type.items[i].state = 0
      elsif button == true and type.items[i].state == 2
        if minus_money
          change_information(1,location)
          type.items[i].state = 1
          add_money(-100)
        else
          puts "You not have enough money to buy this items"
        end
      end
    end
    
    def change_information(a,i)
      File.open('product.txt', 'r+') do |file|
        lines = file.each_line.to_a
        lines[i] = "#{a}\n"
        file.rewind
        file.write(lines.join)
      end
    end

    def button_down(id)
        case id
        when Gosu::KB_ESCAPE
          close
        when Gosu::MsLeft
          change_button(@button1,@food,@i1,4)
          change_button(@button2,@food,@i2,8)
          change_button(@button3,@food,@i3,12)
          change_button(@button4,@food,@i4,16)
          change_button(@button5,@food,@i5,20)
          change_button(@button6,@food,@i6,24)
          change_button(@button7,@food,@i7,28)
          change_button(@button8,@food,@i8,32)
          change_button(@button9,@hunter,@i9,38)
          change_button(@button10,@hunter,@i10,42)
          change_button(@button11,@hunter,@i11,46)
        end
    end

end

# Shop.new.show









































