require 'presenter'

describe Presenter::CPF do
  it 'outputs a formatted CPF' do
    presenter = Presenter::CPF.new('47788423165')
    cpf = CPF.new('47788423165')
    expect(presenter.output).to eq(cpf.formatted)
  end
end
