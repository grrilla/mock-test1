class Battery < Item

  def initialize
    super("Battery", 25)
  end

  def recharge(robot)
    robot.charge_shield
  end

end
