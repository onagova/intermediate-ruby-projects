require './lib/tic_tac_toe'

module TicTacToe
  describe Board do
    subject { Board.new }
    let(:o) { O_MARK }
    let(:x) { X_MARK }

    describe '#make_mark' do
      it 'looks up correct coordinate' do
        coord = instance_double('LetterNumberCoordinate', x: 1, y: 1)
        expect(coord).to receive(:x)
        expect(coord).to receive(:y)
        subject.make_mark(o, coord)
      end

      it 'makes mark in the correct position' do
        coord = instance_double('LetterNumberCoordinate', x: 1, y: 1)
        subject.make_mark(o, coord)

        expected =
          "   A   B   C\n" \
          "1 [ ] [ ] [ ]\n" \
          "2 [ ] [#{o}] [ ]\n" \
          '3 [ ] [ ] [ ]'

        expect(subject.to_s).to eql(expected)
      end

      context 'when end condition is not met' do
        it 'does not lock the board and marks no one as winner' do
          coord0 = instance_double('LetterNumberCoordinate', x: 0, y: 0)
          subject.make_mark(o, coord0)

          expect(subject.locked).to eql(false)
          expect(subject.winner).to eql(' ')
        end
      end

      context 'when end condition is met' do
        context 'with full row' do
          context 'with O mark' do
            it 'locks the board and marks O as winner' do
              coord0 = instance_double('LetterNumberCoordinate', x: 0, y: 0)
              coord1 = instance_double('LetterNumberCoordinate', x: 1, y: 0)
              coord2 = instance_double('LetterNumberCoordinate', x: 2, y: 0)
              subject.make_mark(o, coord0)
              subject.make_mark(o, coord1)
              subject.make_mark(o, coord2)

              expect(subject.locked).to eql(true)
              expect(subject.winner).to eql(o)
            end
          end

          context 'with X mark' do
            it 'locks the board and marks X as winner' do
              coord0 = instance_double('LetterNumberCoordinate', x: 0, y: 2)
              coord1 = instance_double('LetterNumberCoordinate', x: 1, y: 2)
              coord2 = instance_double('LetterNumberCoordinate', x: 2, y: 2)
              subject.make_mark(x, coord0)
              subject.make_mark(x, coord1)
              subject.make_mark(x, coord2)

              expect(subject.locked).to eql(true)
              expect(subject.winner).to eql(x)
            end
          end
        end

        context 'with full column' do
          context 'with O mark' do
            it 'locks the board and marks O as winner' do
              coord0 = instance_double('LetterNumberCoordinate', x: 0, y: 0)
              coord1 = instance_double('LetterNumberCoordinate', x: 0, y: 1)
              coord2 = instance_double('LetterNumberCoordinate', x: 0, y: 2)
              subject.make_mark(o, coord0)
              subject.make_mark(o, coord1)
              subject.make_mark(o, coord2)

              expect(subject.locked).to eql(true)
              expect(subject.winner).to eql(o)
            end
          end

          context 'with X mark' do
            it 'locks the board and marks X as winner' do
              coord0 = instance_double('LetterNumberCoordinate', x: 2, y: 0)
              coord1 = instance_double('LetterNumberCoordinate', x: 2, y: 1)
              coord2 = instance_double('LetterNumberCoordinate', x: 2, y: 2)
              subject.make_mark(x, coord0)
              subject.make_mark(x, coord1)
              subject.make_mark(x, coord2)

              expect(subject.locked).to eql(true)
              expect(subject.winner).to eql(x)
            end
          end
        end

        context 'with full diagonal' do
          context 'with O mark' do
            it 'locks the board and marks O as winner' do
              coord0 = instance_double('LetterNumberCoordinate', x: 0, y: 0)
              coord1 = instance_double('LetterNumberCoordinate', x: 1, y: 1)
              coord2 = instance_double('LetterNumberCoordinate', x: 2, y: 2)
              subject.make_mark(o, coord0)
              subject.make_mark(o, coord1)
              subject.make_mark(o, coord2)

              expect(subject.locked).to eql(true)
              expect(subject.winner).to eql(o)
            end
          end

          context 'with X mark' do
            it 'locks the board and marks X as winner' do
              coord0 = instance_double('LetterNumberCoordinate', x: 2, y: 0)
              coord1 = instance_double('LetterNumberCoordinate', x: 1, y: 1)
              coord2 = instance_double('LetterNumberCoordinate', x: 0, y: 2)
              subject.make_mark(x, coord0)
              subject.make_mark(x, coord1)
              subject.make_mark(x, coord2)

              expect(subject.locked).to eql(true)
              expect(subject.winner).to eql(x)
            end
          end
        end

        context 'with full board' do
          it 'locks the board and marks no one as winner' do
            coord0 = instance_double('LetterNumberCoordinate', x: 0, y: 0)
            coord1 = instance_double('LetterNumberCoordinate', x: 1, y: 0)
            coord2 = instance_double('LetterNumberCoordinate', x: 2, y: 0)
            coord3 = instance_double('LetterNumberCoordinate', x: 0, y: 1)
            coord4 = instance_double('LetterNumberCoordinate', x: 1, y: 1)
            coord5 = instance_double('LetterNumberCoordinate', x: 2, y: 1)
            coord6 = instance_double('LetterNumberCoordinate', x: 0, y: 2)
            coord7 = instance_double('LetterNumberCoordinate', x: 1, y: 2)
            coord8 = instance_double('LetterNumberCoordinate', x: 2, y: 2)
            subject.make_mark(o, coord0)
            subject.make_mark(x, coord1)
            subject.make_mark(o, coord2)
            subject.make_mark(x, coord3)
            subject.make_mark(o, coord4)
            subject.make_mark(x, coord5)
            subject.make_mark(x, coord6)
            subject.make_mark(o, coord7)
            subject.make_mark(x, coord8)

            expect(subject.locked).to eql(true)
            expect(subject.winner).to eql(' ')
          end
        end
      end

      it 'raises custom error when board is already locked' do
        coord0 = instance_double('LetterNumberCoordinate', x: 0, y: 0)
        coord1 = instance_double('LetterNumberCoordinate', x: 1, y: 0)
        coord2 = instance_double('LetterNumberCoordinate', x: 2, y: 0)
        coord3 = instance_double('LetterNumberCoordinate', x: 0, y: 1)
        coord4 = instance_double('LetterNumberCoordinate', x: 1, y: 1)
        coord5 = instance_double('LetterNumberCoordinate', x: 2, y: 1)
        coord6 = instance_double('LetterNumberCoordinate', x: 0, y: 2)
        coord7 = instance_double('LetterNumberCoordinate', x: 1, y: 2)
        coord8 = instance_double('LetterNumberCoordinate', x: 2, y: 2)
        subject.make_mark(o, coord0)
        subject.make_mark(x, coord1)
        subject.make_mark(o, coord2)
        subject.make_mark(x, coord3)
        subject.make_mark(o, coord4)
        subject.make_mark(x, coord5)
        subject.make_mark(x, coord6)
        subject.make_mark(o, coord7)
        subject.make_mark(x, coord8)

        expect { subject.make_mark(o, coord0) }.to raise_error(CustomError)
      end

      it 'raises custom error when mark is not O or X' do
        coord0 = instance_double('LetterNumberCoordinate', x: 0, y: 0)

        expect { subject.make_mark('Y', coord0) }.to raise_error(CustomError)
      end

      it 'raises custom error when coord is out of bounds' do
        coord0 = instance_double('LetterNumberCoordinate', x: -1, y: 3)

        expect { subject.make_mark(o, coord0) }.to raise_error(CustomError)
      end

      it 'raises custom error when coord is already marked' do
        coord0 = instance_double('LetterNumberCoordinate', x: 0, y: 0)
        subject.make_mark(x, coord0)

        expect { subject.make_mark(o, coord0) }.to raise_error(CustomError)
      end
    end
  end

  describe LetterNumberCoordinate do
    describe '::get_instance' do
      it 'returns new instance with valid argument' do
        coord = LetterNumberCoordinate.get_instance('B2')
        expect(coord.x).to eql(1)
        expect(coord.y).to eql(1)
      end

      it 'raises error with invalid argument' do
        expect { LetterNumberCoordinate.get_instance('2B') }.to raise_error(CustomError)
      end
    end
  end
end
