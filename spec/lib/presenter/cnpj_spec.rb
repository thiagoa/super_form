require 'presenter'

describe Presenter::CNPJ do
  it 'outputs a formatted CNPJ' do
    presenter = Presenter::CNPJ.new('79371223118469')
    cnpj = CNPJ.new('79371223118469')
    expect(presenter.output).to eq(cnpj.formatted)
  end
end
