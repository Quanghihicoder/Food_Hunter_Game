# Encoding: UTF-8

require 'rubygems'
require 'gosu'

SCREEN_HEIGHT, SCREEN_WIDTH = 800, 1000

module ZOrder
  BACKGROUND, FOOD, PLAYER, UI = *0..3
end

#*******************************#  Code for Shop #***********************************#
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
        @font.draw_text("Back", 20, 20 , ZOrder::UI, 2.0, 2.0, Gosu::Color::WHITE)
        @font.draw_text("Shop for Hunter", 350, 20 , ZOrder::UI, 2.0, 2.0, Gosu::Color::WHITE)
        # puts ("#{mouse_x} ; #{mouse_y}")
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
    
    def mouse_click(mouse_x,mouse_y)
      if mouse_x < 100 and mouse_x > 20
        if mouse_y < 50 and mouse_y > 20
          return 0
        end
      end
    end


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
          button = mouse_click(mouse_x,mouse_y)
          case button
          when 0
            close
            Home.new.show
          end
        end
    end
end

# Shop.new.show

#*******************************#  Code for Game #***********************************#
def set_product
  $product_selected = collect()
  $food1 = $product_selected[0].strip
  $small_food1 = $product_selected[1].strip
  $food2 = $product_selected[2].strip
  $small_food2 = $product_selected[3].strip
  $food3 = $product_selected[4].strip
  $small_food3 = $product_selected[5].strip
  $food4 = $product_selected[6].strip
  $small_food4 = $product_selected[7].strip
  $hunter = $product_selected[8].strip
  $small_hunter = $product_selected[9].strip
end



class Hunter
  attr_accessor :score, :image, :yuk, :yum, :hunted, :hunted_image, :vel_x, :vel_y, :angle, :x, :y, :score, :hunter_heart, :smallhunter

  def initialize(hunted)
    @image = Gosu::Image.new($hunter)
    @smallhunter = Gosu::Image.new($small_hunter)
    @yuk = Gosu::Sample.new("media/Yuk.wav")
    @yum = Gosu::Sample.new("media/Yum.wav")

    @hunted = hunted  
    @hunted_image = Gosu::Image.new($small_food1)

    @vel_x = @vel_y = 3.0
    @x = @y = @angle = 0.0
    @score = 0
    @hunter_heart = 5
  end
end

class Competitor
  attr_accessor :image, :hunted, :vel_x, :vel_y, :angle, :x, :y

  def initialize()
      @image = Gosu::Image.new("media/Competitor.png")

  
      @hunted = hunted  
        
      @vel_x = @vel_y = 2.0
      @x = @y = @angle = 0.0

  end
end

def set_hunted(hunter, hunted)
  hunter.hunted = hunted
  case hunted
  when :food1
    hunted_string = $small_food1
  when :food2
    hunted_string = $small_food2
  when :food3
    hunted_string = $small_food3
  when :food4
    hunted_string = $small_food4
  end
  hunter.hunted_image = Gosu::Image.new(hunted_string)
end

def warp(hunter, x, y)
  hunter.x, hunter.y = x, y
end

def move_left hunter
  hunter.x -= hunter.vel_x
  hunter.x %= SCREEN_WIDTH
end

def move_right hunter
  hunter.x += hunter.vel_x
  hunter.x %= SCREEN_WIDTH
end

def move_up hunter
  hunter.y -= hunter.vel_y
  hunter.y %= SCREEN_HEIGHT
end

def move_down hunter
  hunter.y += hunter.vel_y
  hunter.y %= SCREEN_HEIGHT
end

def draw_hunter hunter
  hunter.image.draw_rot(hunter.x, hunter.y, ZOrder::PLAYER, hunter.angle)
  hunter.hunted_image.draw_rot(hunter.x, hunter.y, ZOrder::PLAYER, hunter.angle)
  hunter.smallhunter.draw_rot(SCREEN_WIDTH-120, 25, ZOrder::UI)
end

def draw_competitor competitor
  competitor.image.draw_rot(competitor.x, competitor.y, ZOrder::PLAYER, competitor.angle)
end

def target(competitor , food)
  if competitor.x < food.x
    move_right competitor
  end
  if competitor.x > food.x
    move_left competitor
  end
  if competitor.y < food.y 
    move_down competitor
  end
  if competitor.y > food.y
    move_up competitor
  end
end


def collect_food(all_food, hunter, competitor)
  all_food.reject! do |food|
    if Gosu.distance(hunter.x, hunter.y, food.x, food.y) < 80 
      if (food.type == hunter.hunted)
        hunter.score += 1
        hunter.yum.play
      else
        hunter.hunter_heart += -1
        hunter.yuk.play
      end
      true
    elsif Gosu.distance(competitor.x, competitor.y, food.x, food.y) < 80
      true
    else
      false
    end
  end
end


class Food

  attr_accessor :x, :y, :type, :image, :vel_x, :vel_y, :angle, :x, :y, :score

  def initialize(image, type)
    @type = type
    @image = Gosu::Image.new(image)
    @vel_x = rand(-2 .. 2)  # rand(1.2 .. 2.0)
    @vel_y = rand(-2 .. 2)
    @angle = 0.0

    @x = rand * SCREEN_WIDTH
    @y = rand * SCREEN_HEIGHT
    @score = 0
  end
end

def move food
  food.x += food.vel_x
  food.x %= SCREEN_WIDTH
  food.y += food.vel_y
  food.y %= SCREEN_HEIGHT
end

def draw_food food
  food.image.draw_rot(food.x, food.y, ZOrder::FOOD, food.angle)
end

class FoodHunterGame < (Example rescue Gosu::Window)
  def initialize

    # replace hard coded values with global constants:

    super SCREEN_WIDTH, SCREEN_HEIGHT
    self.caption = "Food Hunter Game"

    @background_image = Gosu::Image.new("media/space.png", :tileable => true)

    @all_food = Array.new

    set_product()
    # Food is created later in generate-food
    @competitor = Competitor.new

    @player = Hunter.new(:food1)

    warp(@player, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)

    warp(@competitor, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)

    @font = Gosu::Font.new(20)
  end

  def update
    if @player.hunter_heart <= 0 
      $result = @player.score 
      write_record($result)
      add_money($result)
      close
      Result.new.show if __FILE__ == $0
    end

    if Gosu.button_down? Gosu::KB_LEFT or Gosu.button_down? Gosu::GP_LEFT
      move_left @player
    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu.button_down? Gosu::GP_RIGHT
      move_right @player
    end
    if Gosu.button_down? Gosu::KB_UP or Gosu.button_down? Gosu::GP_BUTTON_0
      move_up @player
    end
    if Gosu.button_down? Gosu::KB_DOWN or Gosu.button_down? Gosu::GP_BUTTON_9
      move_down @player
    end

    @all_food.each { |food| move food }

    self.remove_food

    @all_food.each do |food|
      target(@competitor, food)
    end

    collect_food(@all_food, @player , @competitor)

   if rand(100) < 2 and @all_food.size < 5
     if @status 
      @all_food.push(change_direction)
    else
      @all_food.push(generate_food)
    end
   end

   # change the hunted food randomly:
   if rand(300) == 0 or Gosu::button_down? Gosu::KbSpace
     change = rand(4)
     case change
      when 0
        set_hunted(@player, :food1)
      when 1
        set_hunted(@player, :food2)
      when 2
        set_hunted(@player, :food3)
      when 3
        set_hunted(@player, :food4)
     end
   end
 end

 def change_direction
    if @t == 0
      Food.new($food1, :food1)
    elsif @t == 1 
      Food.new($food2, :food2)
    elsif @t == 2  
      Food.new($food3, :food3)
    elsif @t == 3  
      Food.new($food4, :food4)
    end
  end

  
  def wait()
    t = Time.new(0)
    time_in_seconds = 1 
    time_in_seconds.downto(0) do |seconds|
    self.sleep 0.3
    end
    return true
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    draw_hunter @player
    draw_competitor @competitor
    @all_food.each do |food|
      i = rand(2000)
      if i == 520
        food.image = Gosu::Image.new("media/smoke.png")
        
        if food.type == :food1
          @t = 0
        elsif food.type == :food2
          @t = 1
        elsif food.type == :food3
          @t = 2
        elsif food.type == :food4
          @t = 3
        end
       
        food.type = "remove"
      end
    end
    @all_food.each { |food| draw_food food }
    @font.draw_text("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw_text("X #{@player.hunter_heart}", SCREEN_WIDTH - 90, 20, ZOrder::UI, 1.0,1.0,Gosu::Color::YELLOW)
  end

  def generate_food
    case rand(4)
    when 0
      Food.new($food1, :food1)
    when 1
      Food.new($food2, :food2)
    when 2
      Food.new($food3, :food3)
    when 3
      Food.new($food4, :food4)
    end
  end

  def remove_food
    @all_food.reject! do |food|
      # Replace the following hard coded values with global constants:
      if food.x > SCREEN_WIDTH || food.y > SCREEN_HEIGHT || food.x < 0 || food.y < 0
        true
      elsif food.type == "remove"
        if wait()
          @status = true
          true
        end
      else
        @status = false
        false
      end
    end
  end
  
  def write_record(record)
    my_data = File.readlines("record.txt").sort_by { |x| x[/\d+/].to_i }
    if my_data.include?("#{record}\n") == false
      record_file = File.open("record.txt", "a+")
      record_file.puts(record)
      record_file.close
    end
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    end
  end
end

#FoodHunterGame.new.show if __FILE__ == $0

#*******************************#  Code for Result #***********************************#
class Result < Gosu::Window
  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    @background = Gosu::Image.new("media/space.png")
    @hunter_image = Gosu::Image.new($hunter)
    @font = Gosu::Font.new(50)
    self.caption = "Food Hunter Game"
  end

  def draw
    @background.draw(0,0, ZOrder::BACKGROUND)
    @hunter_image.draw(306,236, ZOrder::BACKGROUND, 1.0, 1.0)
    @font.draw_text("The hunter need more food!",220,100,ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
    @font.draw_text("Your score: ",500,220,ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw_text($result,580,300,ZOrder::UI, 3.0, 3.0, Gosu::Color::YELLOW)
    Gosu.draw_rect(320, 550, SCREEN_WIDTH/3, SCREEN_HEIGHT/10, Gosu::Color::GREEN, ZOrder::UI, mode=:default)  
    @font.draw_text("PLAY AGIAN", 350, 570 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    Gosu.draw_rect(320, 700, SCREEN_WIDTH/3, SCREEN_HEIGHT/10, Gosu::Color::GREEN, ZOrder::UI, mode=:default)
    @font.draw_text("HOME", 420, 720 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    # puts ("#{mouse_x} ; #{mouse_y}")
  end

  def needs_cursor?; true; end

  def mouse_over_button(mouse_x, mouse_y)
    if (mouse_x < 650 && mouse_x > 320)
      if (mouse_y < 629 && mouse_y > 547)
        return 0
      end
      if (mouse_y < 780 && mouse_y > 700)
        return 1
      end
    end
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    end
    case id
    when Gosu::MsLeft
      button = mouse_over_button(mouse_x,mouse_y)
      case button
      when 0
        close
        FoodHunterGame.new.show if __FILE__ == $0
      when 1
        close 
        Home.new.show if __FILE__ == $0
      end
    end
  end
end

#*******************************#  Code for Record #***********************************#
class Record < Gosu::Window
  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    @background = Gosu::Image.new("media/space.png")
    @font = Gosu::Font.new(50)
    self.caption = "Food Hunter Game"
  end
  
  def draw
    @background.draw(0,0, ZOrder::BACKGROUND)
    @font.draw_text("It is not enough for the hunter!",220,100,ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
    Gosu.draw_rect(340, 700, SCREEN_WIDTH/3, SCREEN_HEIGHT/10, Gosu::Color::GREEN, ZOrder::UI, mode=:default)
    @font.draw_text("HOME", 440, 720 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    read_and_sort_file()
    # puts ("#{mouse_x} ; #{mouse_y}")
  end

  def needs_cursor?; true; end

  def read_and_sort_file()
    @my_data = File.readlines("record.txt").sort_by { |x| x[/\d+/].to_i }
    @first = @my_data[-1]
    @second = @my_data[-2]
    @third = @my_data[-3]
    @font.draw_text("First: #{@first}", 420, 200 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @font.draw_text("Second: #{@second}", 420, 300 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @font.draw_text("Third: #{@third}", 420, 400 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end


  def mouse_over_button(mouse_x, mouse_y)
    if (mouse_x < 670 && mouse_x > 340)
      if (mouse_y < 780 && mouse_y > 700)
        return 1
      end
    end
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    end
    case id
    when Gosu::MsLeft
      button = mouse_over_button(mouse_x,mouse_y)
      case button
      when 1
        close
        Home.new.show if __FILE__ == $0
      end
    end
  end
end

#*******************************#  Code for Home #***********************************#
class Home < Gosu::Window

  # set up variables and attributes
  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    @background = Gosu::Image.new("media/background.png")
    @button_font = Gosu::Font.new(50)
    self.caption = "Food Hunter Game"
    @cap_image = Gosu::Image.new("media/Cap.png")
    @cap2 = Gosu::Image.new("media/cap2.png")
  end

  def draw
    # Draw background color
    @background.draw(0,0, ZOrder::BACKGROUND)
    
    # Draw the button "Play"
    Gosu.draw_rect(129,537 , 350, 80, Gosu::Color::GREEN, ZOrder::UI, mode=:default)
    # Draw the button "High Score"
    Gosu.draw_rect(129,643 , 350, 80, Gosu::Color::GREEN, ZOrder::UI, mode=:default)
    #Draw the button "Shop"
    Gosu.draw_rect(550,537 , 350, 80, Gosu::Color::GREEN, ZOrder::UI, mode=:default)
    #Draw cap
    @cap_image.draw(220,100, ZOrder::BACKGROUND)
    #Draw cap2
    @cap2.draw(365,190, ZOrder::BACKGROUND, 1.5, 1.0)


    # Draw the text "Play"
    @button_font.draw_text("PLAY", 240, 500 + 50 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    # Draw the text "High Score"
    @button_font.draw_text("RECORD", 210, 660 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    # Draw the text "Shop"
    @button_font.draw_text("SHOP", 660, 550 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end

  # this is called by Gosu to see if it should show the cursor (or mouse)
  def needs_cursor?; true; end

 # This needs to be fixed!

  def mouse_over_button(mouse_x, mouse_y)
    if mouse_x.between?(129, 479)  
      if mouse_y.between?(537, 617)
        return 0
      elsif mouse_y.between?(643, 723)
        return 1
      end
    elsif mouse_x.between?(550, 900)  
      if mouse_y.between?(537, 617)
        return 2
      end
    end
  end

  def button_down(id)
    case id
    when Gosu::KB_ESCAPE
      close
    when Gosu::MsLeft
      button = mouse_over_button(mouse_x, mouse_y)
      case button
      when 0
        close
        FoodHunterGame.new.show if __FILE__ == $0
      when 1
        close
        Record.new.show if __FILE__ == $0
      when 2
        close
        Shop.new.show if __FILE__ == $0
      end
    end
  end
end


Home.new.show if __FILE__ == $0






