require_relative 'spec_helper'

describe Robot do

  subject { Robot.new }

  describe '#heal!' do
    context 'robot is dead' do
      it 'should raise an error' do
        allow(subject).to receive(:dead?).and_return(true)
        expect {
          subject.heal!(20)
        }.to raise_error Robot::InvalidTargetError, 'Cannot revive a dead robot!'
      end
    end

    context 'robot is alive' do
      it 'should call the heal function' do
        expect(subject).to receive(:heal)
        subject.heal!(20)
      end
    end
  end

  describe '#attack!' do
    context 'target is a robot' do
      it 'should wound target robot' do
        robot = double()
        allow(robot).to receive(:is_a?).with(Robot).and_return(true)
        expect(robot).to receive(:wound)
        subject.attack!(robot)
      end
    end

    context 'target is not a robot' do
      it 'should raise an error' do
        robot = double()
        allow(robot).to receive(:is_a?).with(Robot).and_return(false)
        expect {
          subject.attack!(robot)
        }.to raise_error Robot::InvalidTargetError, 'Can only attack other robots!'
      end
    end
  end
end
