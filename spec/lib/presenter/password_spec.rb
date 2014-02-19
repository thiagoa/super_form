require 'presenter'

describe Presenter::Password do
  it 'outputs nil' do
    presenter = Presenter::Password.new('secret')
    expect(presenter.output).to eq nil
  end
end
