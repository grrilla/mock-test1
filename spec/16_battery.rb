require_relative 'spec_helper'

describe Battery do

  subject { Battery.new }

  it 'should have a name "Battery"' do
    expect(subject.name).to eq "Battery"
  end

  it 'should have a weight of 25' do
    expect(subject.weight).to eq 25
  end

  describe '#recharge' do

    before :each do
      @robot = Robot.new
    end

    context 'robot has full shield' do
      it 'should not change sp' do
        @robot.pick_up(subject)
        expect(@robot.shield).to eq Robot::STARTING_SHIELD
      end
    end

    context 'robot is missing some sp' do
      it 'should charge shield to full' do
        @robot.wound(20)
        expect(@robot.shield).to eq (Robot::STARTING_SHIELD - 20)
        @robot.pick_up(subject)
        expect(@robot.shield).to eq Robot::STARTING_SHIELD
      end
    end
  end

end
