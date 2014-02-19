describe Presenter::PersonType do
  it 'outputs the person type description' do
    person = PersonType.new(PersonType::LEGAL)
    presenter = Presenter::PersonType.new(PersonType::LEGAL)

    expect(presenter.output).to eq person.description
  end
end
