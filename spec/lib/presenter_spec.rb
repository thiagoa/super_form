require 'presenter'
require File.expand_path('../../support/presenter_name', __FILE__)

module Presenter
  describe Base do
    it_behaves_like 'presenter nameable'

    describe 'delegates to the source object' do
      it 'calls the source object correspondent methods' do
        source = stub_source_object([:name, :phone])
        presenter = Base.new(source)

        expect(source).to receive(:name)
        expect(source).to receive(:phone)

        presenter.name
        presenter.phone
      end

      it 'returns the same values as the source object' do
        source = stub_source_object([:name, :phone])
        presenter = Base.new(source)

        expect(presenter.name).to eq (source.name)
        expect(presenter.phone).to eq (source.phone)
      end
    end

    describe '.map' do
      context 'with one mapping specified' do
        it 'assigns specified attribute to specified "each presenter"' do
          presenter = stub_presenter(:inexistent) { map :inexistent => :fake }
          fake_presenter = stub_each_presenter(:fake, presenter)

          expect(presenter.inexistent).to eq fake_presenter.output
        end
      end

      context 'with multiple mappings specified' do
        it 'assigns specified attributes to specified "each presenters"' do
          presenter = stub_presenter(:inexistent, :power) do
            map :inexistent => :fake, :power => :chord
          end

          fake = stub_each_presenter(:fake, presenter)
          chord = stub_each_presenter(:chord, presenter)

          expect(presenter.inexistent).to eq fake.output
          expect(presenter.power).to eq chord.output
        end
      end

      it 'tries to guess the presenter when no presenter is assigned' do
        presenter = stub_presenter(:something) { map :something => :fake }

        class Fake < Each
          def output
            '123456'
          end
        end

        expect(presenter.something).to eq('123456')
      end
    end

    describe '.use' do
      context 'with one presenter specified' do
        it 'uses one presenter' do
          presenter = stub_presenter(:inexistent) { use :inexistent }
          inexistent = stub_each_presenter(:inexistent, presenter)

          expect(presenter.inexistent).to eq inexistent.output
        end
      end

      context 'with multiple presenters specified' do
        it 'uses multiple presenters' do
          presenter = stub_presenter(:inexistent, :fake) do
            use :inexistent, :fake
          end

          inexistent = stub_each_presenter(:inexistent, presenter)
          fake = stub_each_presenter(:fake, presenter)

          expect(presenter.inexistent).to eq inexistent.output
          expect(presenter.fake).to eq fake.output
        end
      end

      it 'tries to guess the presenter when no presenter is assigned' do
        presenter = stub_presenter(:inexistent) { use :inexistent }

        class Inexistent < Each
          def output
            '12345'
          end
        end

        expect(presenter.inexistent).to eq('12345')
      end

      it 'works if given a presenter class instead of a symbol' do
        each_presenter = Class.new(Each) do
          def self.__name__
            'fake'
          end

          def output
            'it works'
          end
        end

        presenter = stub_presenter(:fake) { map :fake => each_presenter }
        expect(presenter.fake).to eq('it works')
      end
    end
  end

  describe Each do
    it_behaves_like 'presenter nameable'

    it 'can access the raw value' do
      presenter = Each.new('some value')
      expect(presenter.value).to eq('some value')
    end

    it 'outputs the raw value by default' do
      presenter = Each.new('some value')
      expect(presenter.output).to eq(presenter.value)
    end

    it 'delegates to :output when :to_s is called' do
      presenter = Each.new('some value')
      expect(presenter.to_s).to eq(presenter.output)
    end
  end
end

def stub_source_object(params)
  source = Object.new

  Array(params).each do |p|
    source.stub(p).and_return(p.to_s)
  end

  source
end

def stub_presenter(*source_params, &block)
  source = stub_source_object(source_params)
  Class.new(Presenter::Base, &block).new(source)
end

def stub_each_presenter(id, presenter = nil)
  each_presenter = Class.new(Presenter::Each) do
    def output
      'output'
    end
  end.new

  if presenter
    presenter.send("#{id}_presenter=", each_presenter)
  end

  each_presenter
end
