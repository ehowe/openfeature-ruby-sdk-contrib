RSpec.shared_examples_for "returning nil" do |method, flag_key|
  subject { instance.public_send(method, flag_key: flag_key) }

  it { is_expected.to be_nil }
end

RSpec.shared_examples_for "returning the default value" do |method, flag_key, default_value|
  subject { instance.public_send(method, flag_key: flag_key, default_value: default_value) }

  it { is_expected.to eq(default_value) }
end

RSpec.shared_examples_for "raising an invalid type error" do |method, flag_key, default_value = nil|
  subject { instance.public_send(method, flag_key: flag_key, default_value: default_value) }

  it "raises an error" do
    expect { subject }.to raise_error(OpenFeature::SDK::Contrib::InvalidReturnValueError)
  end
end

RSpec.shared_examples_for "reading from the cache" do |method, flag_key, value|
  subject { instance.public_send(method, flag_key: flag_key) }

  before do
    instance.cache_duration = 60
    instance.instance_variable_set(:@last_cache, Time.now.to_i - 10)
    instance.instance_variable_set(:@flag_contents, raw)
  end

  it "returns the value from the cache without reading the file" do
    expect(File).not_to receive(:read).with(file_path)

    expect(subject).to eq(value)
  end
end

RSpec.shared_examples_for "reading the value" do |method, flag_key, value|
  subject { instance.public_send(method, flag_key: flag_key) }

  it { is_expected.to eq(value) }
end