shared_examples "presenter nameable" do
  describe '.name' do
    it 'returns a demodulized and underscored presenter name' do
      presenter = Class.new(described_class) do
        def self.name
          'Presenter::Deep::IDontExist'
        end
      end

      expect(presenter.__name__).to eq 'i_dont_exist'
    end

    it 'trims _presenter suffix' do
      presenter = Class.new(described_class) do
        def self.name
          'Presenter::Deep::IDontExistPresenter'
        end
      end

      expect(presenter.__name__).to eq 'i_dont_exist'
    end

    it 'raises an exception if presenter is anonymous' do
      presenter = Class.new(described_class)
      expect { presenter.__name__ }.to raise_error RuntimeError
    end
  end
end
