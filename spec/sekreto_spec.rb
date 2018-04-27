RSpec.describe Sekreto do
  subject(:sekreto) { described_class }

  let(:manager) { double }
  let(:secret_id) { 'MY_SECRET' }
  let(:secret_response) { OpenStruct.new(secret_string: secret_string) }

  describe 'setup' do
    context 'when no block given' do
      before { sekreto.setup }

      it 'does not yield config' do
        expect(sekreto.instance_variable_get(:@config)).to be nil
      end
    end

    context 'when block given' do
      before do
        sekreto.setup {}
      end

      it 'initializes a config object' do
        expect(sekreto.instance_variable_get(:@config)).to be_an_instance_of(described_class::Config)
      end
    end
  end

  describe 'get_value' do
    let(:secret_string) { 'my-scret-string' }
    let(:config) { sekreto.config }

    before do
      sekreto.setup do |setup|
        setup.is_allowed_env = -> { allowed_env }
      end
    end

    context 'when not allowed env' do
      let(:allowed_env) { false }
      let(:fallback) { double }

      it 'calls fallback lookup' do
        allow(config).to receive(:fallback_lookup) { fallback }
        allow(fallback).to receive(:call).once.with(secret_id)
        sekreto.get_value(secret_id)
      end
    end

    context 'when allowed env' do
      let(:allowed_env) { true }

      before do
        allow(described_class).to receive(:secrets_manager) { manager }
        allow(manager).to receive(:get_secret_value) { secret_response }
      end

      it 'gets secret value from manager' do
        expect(sekreto.get_value(secret_id)).to eq(secret_string)
      end
    end
  end

  describe 'get_json_value' do
    let(:secret_string) { '{ "value": "my-scret-string" }' }
    let(:allowed_env) { true }

    before do
      sekreto.setup do |setup|
        setup.is_allowed_env = -> { allowed_env }
      end
    end

    context 'when valid json secret' do
      before do
        allow(described_class).to receive(:secrets_manager) { manager }
        allow(manager).to receive(:get_secret_value) { secret_response }
      end

      it 'returns parsed secret' do
        expect(sekreto.get_json_value(secret_id)).to eq(MultiJson.load(secret_string))
      end
    end
  end
end
