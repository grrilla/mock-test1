require_relative 'spec_helper'

describe Robot do

  describe '#Robot.in_position(x,y)' do
    context 'origin is empty, no bots yet' do
      it 'should say there are no bots on the origin' do
        expect(Robot.in_position(0, 0)).to eq []
      end
    end

    context 'made first bot' do
      before :all do
        @r1 = Robot.new
      end

      it 'should show up on the origin' do
        expect(Robot.in_position(0, 0)).to eq [@r1]
      end

      context 'made second bot' do
        before :all do
          @r2 = Robot.new
        end

        it 'should also show up on the origin' do
          expect(Robot.in_position(0, 0)).to eq [@r1, @r2]
        end

        it 'should show space above them to be empty' do
          expect(Robot.in_position(0, 1)).to eq []
        end

        context 'moved first bot up one' do
          before :all do
            @r1.move_up
          end

          it 'should should show the first bot at [0,1]' do
            expect(Robot.in_position(0, 1)).to eq [@r1]
          end

          it 'should show ONLY the second bot at the origin' do
            expect(Robot.in_position(0, 0)).to eq [@r2]
          end
        end

        context 'moved the second bot up one' do
          before :all do
            @r2.move_up
          end

          it 'should should show both bots at [0,1]' do
            expect(Robot.in_position(0, 1)).to eq [@r1, @r2]
          end

          it 'should show the the origin to be empty' do
            expect(Robot.in_position(0, 0)).to eq []
          end
        end
      end
    end
  end
end
