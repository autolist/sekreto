RSpec.describe Sekreto::Config do
  describe 'initialize' do
    subject(:config) { described_class.new }

    it 'defaults prefix' do
      expect(config.prefix).to eq('secrets')
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
end
