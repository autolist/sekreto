RSpec.describe Sekreto::Config do
  subject(:config) { described_class.new }

  describe 'initialize' do
    it 'defaults prefix' do
      expect(config.prefix).to eq(described_class::DEFAULT_PREFIX)
    end

    it 'defaults allowed env to true' do
      expect(config.is_allowed_env.call).to eq(true)
    end

    it 'has no secrets manager' do
      expect(config.secrets_manager).to be_nil
    end

    context 'when fallback lookup' do
      let(:secret_id) { 'MY_SECRET' }
      let(:secret_val) { 'MY_SECRET_VAL' }

      before { stub_env(secret_id, secret_val) }

      it 'defaults to check ENV' do
        expect(config.fallback_lookup.call(secret_id)).to eq(secret_val)
      end
    end
  end

  describe 'prefix_name' do
    let(:prefix_name) { config.prefix_name(path) }

    context 'when false path' do
      let(:path) { false }

      it 'returns nil' do
        expect(prefix_name).to be_nil
      end
    end

    context 'when nil path' do
      let(:path) { nil }

      it 'returns config prefix' do
        expect(prefix_name).to eq(described_class::DEFAULT_PREFIX)
      end
    end

    context 'when path passed in' do
      let(:path) { 'la-la-la' }

      it 'returns config prefix' do
        expect(prefix_name).to eq(path)
      end
    end
  end
end
