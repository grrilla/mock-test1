require 'pry'

class Robot

  DEFAULT_ATTACK_POWER = 5
  STARTING_HEALTH = 100
  MAX_CAPACITY = 250

  attr_reader :capacity
  attr_accessor :position, :items, :health, :equipped_weapon

  def initialize
    @position = [0, 0]
    @items = []
    @capacity = MAX_CAPACITY
    @health = STARTING_HEALTH
    @equipped_weapon = nil
  end

  def move_left
    @position[0] -= 1
  end

  def move_right
    @position[0] += 1
  end

  def move_down
    @position[1] -= 1
  end

  def move_up
    @position[1] += 1
  end

  def pick_up(item)
    unless item.weight > (@capacity - items_weight)
      @equipped_weapon = item if item.is_a? Weapon
      @items << item
    end
  end

  def items_weight
    total_weight = 0
    @items.each { |item| total_weight += item.weight }
    total_weight
  end

  def wound(hp_loss)
    @health = if hp_loss > @health
      0
    else
      @health - hp_loss
    end
  end

  def heal(hp_gain)
    @health = if hp_gain > (STARTING_HEALTH - @health)
      STARTING_HEALTH
    else
      @health + hp_gain
    end
  end

  def attack(enemy)
    if @equipped_weapon
      @equipped_weapon.hit(enemy)
    else
      enemy.wound(DEFAULT_ATTACK_POWER)
    end
  end

end
