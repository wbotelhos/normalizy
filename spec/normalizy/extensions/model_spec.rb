# frozen_string_literal: true

RSpec.describe '#apply_normalizy' do
  context 'when object has no normalizy' do
    it do
      expect(Model.create(none: '  Botelho  ').none).to eq '  Botelho  '
    end
  end

  context 'when object has normalizy' do
    it do
      Normalizy.configure do |config|
        config.default_filters = [:squish]
      end

      expect(Model.create(default: '  Botelho  ').default).to eq 'Botelho'
    end

    it do
      expect(Model.create(block: 'Botelho').block).to eq 'BOTELHO'
    end
  end

  context 'when a filter is given' do
    it do
      expect(Model.create(symbol: '  Bote  lho  ').symbol).to eq 'Bote lho'
    end

    it do
      expect(Model.create(array_symbol: '  Bote  lho  ').array_symbol).to eq 'Bote lho'
    end

    it do
      expect(Model.create(array_symbols: '  Bote  lho  ').array_symbols).to eq 'bote lho'
    end

    it do
      expect(Model.create(hash_no_args: '  Bote  lho  ').hash_no_args).to eq 'Bote lho'
    end

    it do
      expect(Model.create(hash_with_args: '  Botelho  ').hash_with_args).to eq 'Botelho  '
    end

    it do
      expect(Model.create(module_one_arg: 'Fuck').module_one_arg).to eq 'filtered'
    end

    it do
      expect(Model.create(module_two_args: 'Botelho').module_two_args).to eq 'module_two_args, Botelho, Model'
    end

    it do
      Normalizy.configure do |config|
        config.add :blacklist, Normalizy::Filters::Block
      end

      expect(Model.create(module_and_block: 'Botelho').module_and_block).to eq 'BOTELHO'
    end

    it do
      expect(Model.create(method_with_no_options_field: 'Botelho').method_with_no_options_field).to eq 'Botelho'
    end

    it do
      expect(Model.create(method_with_options_field: 'Botelho').method_with_options_field).to eq [
        'Botelho',
        {
          key:       :value,
          attribute: :method_with_options_field,
          object:    Model.new
        }
      ].join ', '
    end

    it do
      expect(Model.create(native: 'Botelho').native).to eq '["Botelho"]'
    end

    it do
      expect(Model.create(multiple: 'BoteLho').multiple).to eq 'bote lho'
    end
  end

  context 'when assign is made via set' do
    context 'with no save' do
      it do
        object        = Model.new
        object.symbol = '  Bote  lho  '

        expect(object.symbol).to eq 'Bote lho'
      end
    end

    context 'with save' do
      it do
        object        = Model.new
        object.symbol = '  Bote  lho  '
        object.save

        expect(object.symbol).to eq 'Bote lho'
      end
    end
  end
end
