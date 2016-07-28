require_relative 'spec_helper'

describe Robot do

  subject { Robot.new }

  context 'the robot is alone on the board' do
    it 'should return an empty array' do
      expect(subject.scan).to eq []
    end
  end

  context 'the robot is surrounded by bots' do
    before :all do
      @r1 = Robot.new
      @r1.move_up
      @r2 = Robot.new
      @r2.move_down
      @r3 = Robot.new
      @r3.move_right
      @r4 = Robot.new
      @r4.move_left
    end

    it 'should return all bots in an array' do
      expect(subject.scan).to match_array [@r1,@r2,@r3,@r4]
    end

    context 'the robot is sharing the origin with another bot' do
      before :all do
        @r5 = Robot.new
      end

      it 'should still only return the bots ADJACENT to the origin' do
        expect(subject.scan).to match_array [@r1,@r2,@r3,@r4]
      end
    end
  end
end
