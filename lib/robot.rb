class Robot

  class InvalidTargetError < StandardError
  end

  DEFAULT_ATTACK_POWER = 5
  STARTING_HEALTH = 100
  STARTING_SHIELD = 50
  MAX_CAPACITY = 250
  X_INDEX = 0
  Y_INDEX = 1

  attr_reader :capacity, :position, :items, :health, :equipped_weapon, :shield

  @@robot_list = []

  def initialize
    @position = [0, 0]
    @items = []
    @capacity = MAX_CAPACITY
    @health = STARTING_HEALTH
    @equipped_weapon = nil
    @shield = STARTING_SHIELD
    @@robot_list << self
  end

  class << self
    def robot_list
      @@robot_list
    end

    def in_position(x, y)
      @@robot_list.select { |bot| bot.position == [x, y] }
    end
  end

  def move_left
    @position[X_INDEX] -= 1
  end

  def move_right
    @position[X_INDEX] += 1
  end

  def move_down
    @position[Y_INDEX] -= 1
  end

  def move_up
    @position[Y_INDEX] += 1
  end

  def pick_up(item)
    unless item.weight > (@capacity - items_weight)
      @equipped_weapon = item if item.is_a? Weapon
      @items << item unless can_consume?(item)
    end
  end

  def items_weight
    total_weight = 0
    @items.each { |item| total_weight += item.weight }
    total_weight
  end

  def wound(damage)
    if damage >= (health + shield) # if this is enough damage to kill it...
      @health = 0
      @shield = 0
    elsif damage < shield # else, if we have enough shield to absorb hit...
      @shield -= damage
    elsif shield.zero? # else, if we have no shield to absorb damage...
      @health -= damage
    else # ... then we have some shield and enough hp survive the blow, but shield is gone
      @health -= damage - shield
      @shield = 0
    end
  end

  def heal(hp_gain)
    @health = if hp_gain > (STARTING_HEALTH - @health)
      STARTING_HEALTH
    else
      @health + hp_gain
    end
  end

  def heal!(hp_gain)
    raise InvalidTargetError, 'Cannot revive a dead robot!' if dead?
    heal(hp_gain)
  end

  def attack(enemy)
    if @equipped_weapon
      if in_range?(enemy, @equipped_weapon.range)
        @equipped_weapon.hit(enemy)
        @equipped_weapon = nil
      end
    else
      enemy.wound(DEFAULT_ATTACK_POWER) if in_range?(enemy)
    end
  end

  def attack!(enemy)
    raise InvalidTargetError, 'Can only attack other robots!' unless enemy.is_a? Robot
    attack(enemy)
  end

  def dead?
    @health.zero?
  end

  def in_range?(robot, range_mod=1)
    unless @position == robot.position
      if @position[X_INDEX] == robot.position[X_INDEX]
        @position[Y_INDEX] == (robot.position[Y_INDEX] - range_mod) || @position[Y_INDEX] == (robot.position[Y_INDEX] + range_mod)
      elsif @position[Y_INDEX] == (robot.position[Y_INDEX])
        @position[X_INDEX] == (robot.position[X_INDEX] - range_mod) || @position[X_INDEX] == (robot.position[X_INDEX] + range_mod)
      end
    end
  end

  def can_consume?(item)
    if item.is_a?(BoxOfBolts) && health < STARTING_HEALTH
      item.feed(self)
    elsif item.is_a?(Battery) && shield < STARTING_SHIELD
      item.recharge(self)
    end
  end

  def charge_shield
    raise InvalidTargetError, 'Cannot charge shield of a dead robot!' if dead?
    @shield = STARTING_SHIELD
  end

  def shields_full?
    shield == STARTING_SHIELD
  end

  def scan
    up_tile = Robot.in_position(@position[X_INDEX], @position[Y_INDEX] + 1)
    down_tile = Robot.in_position(@position[X_INDEX], @position[Y_INDEX] - 1)
    left_tile = Robot.in_position(@position[X_INDEX] - 1, @position[Y_INDEX])
    right_tile = Robot.in_position(@position[X_INDEX] + 1, @position[Y_INDEX])
    up_tile.concat(down_tile).concat(left_tile).concat(right_tile)
  end

end
