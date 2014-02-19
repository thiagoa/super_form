require 'presenter'

describe Presenter::Telephone do
  it 'outputs a formatted phone' do
    presenter = Presenter::Telephone.new('8811111111')
    phone = Telephone.new('8811111111')
    expect(presenter.output).to eq(phone.formatted)
  end
end
