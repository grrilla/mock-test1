require_relative 'spec_helper'

describe Robot do

  subject { Robot.new }

  context 'robot has shields' do
    it 'should return 50 shields after construction' do
      expect(subject.shield).to eq 50
    end

    describe '#wound' do
      context 'robot has full shields' do
        it 'should remove sp in place of hp' do
          subject.wound(20)
          expect(subject.health).to eq 100
          expect(subject.shield).to eq 30
        end
      end

      context 'robot has no shields' do
        it 'should remove hp to full amount of damage' do
          allow(subject).to receive(:shield).and_return(0)
          subject.wound(20)
          expect(subject.health).to eq 80
          expect(subject.shield).to eq 0
        end
      end

      context 'robot has 1 shield points (out of 50)' do
        it 'should remove remaining sp, then hp for remaing damage' do
          allow(subject).to receive(:shield).and_return(10)
          subject.wound(20)
          expect(subject.health).to eq 90
        end
      end
    end

  end


end
