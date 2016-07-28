class Robot

  class InvalidTargetError < StandardError
  end

  DEFAULT_ATTACK_POWER = 5
  STARTING_HEALTH = 100
  MAX_CAPACITY = 250
  X_INDEX = 0
  Y_INDEX = 1

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
    if item.is_a?(BoxOfBolts) && ((STARTING_HEALTH - self.health) >= 20)
      item.feed(self)
    end
  end

end
