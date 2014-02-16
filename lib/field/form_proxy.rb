module Field
  module FormProxy
    def [](form_class)
      extra = {
        form_class:  form_class,
        field_class: self
      }

      Proxy.new(extra) do |name, options, proxy|
        field = proxy.field_class.new(name, options)
        field.form_class = proxy.form_class
        field
      end
    end
  end
end
