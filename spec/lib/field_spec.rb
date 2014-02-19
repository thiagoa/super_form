require 'field'

describe Field::Base do
  it 'responds to presenter_class' do
    field = Field::Base.new(:fake)
    expect(field).to respond_to :presenter_class
  end

  it 'presenter_class returns nil by default' do
    field = Field::Base.new(:fake)
    expect(field.presenter_class).to be_nil
  end
end
