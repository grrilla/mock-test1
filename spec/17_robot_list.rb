require_relative 'spec_helper'

describe Robot do

  describe '@@robot_list' do
    context 'no robots made yet' do
      it 'should be empty' do
        expect(Robot.robot_list.empty?).to be true
      end
    end

    context 'first robot made' do

      before :all do
        @r1 = Robot.new
      end

      it 'should be 1 in size, containing first bot' do
        expect(Robot.robot_list.size).to eq 1
        expect(Robot.robot_list[0]).to be @r1
      end

      context 'second robot made' do
        it 'should be 2 in size, containing both bots in order of creation' do
          r2 = Robot.new
          expect(Robot.robot_list.size).to eq 2
          expect(Robot.robot_list[0]).to be @r1
          expect(Robot.robot_list[1]).to be r2
        end
      end
    end
  end
end
