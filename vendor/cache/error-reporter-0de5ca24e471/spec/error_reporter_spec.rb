# rubocop:disable Metrics/BlockLength
RSpec.describe ErrorReporter do
  let(:error) do
    begin
      fail 'Mula Khao'
    rescue => error
      error
    end
  end

  let(:reporter_class) do
    Class.new do
      def self.error(_error); end
    end
  end

  let(:extra_data_reporter_class) do
    Class.new do
      def self.error(*_args); end
    end
  end

  after do
    described_class.logger = nil
    described_class.reporters = nil
  end

  shared_examples_for 'log levels' do |level|
    describe ".#{level}" do
      it 'Logs to logger' do
        expect(described_class.logger).to receive(level).with(error.inspect)
        expect(described_class.logger).to receive(level).with(error.backtrace.join("\n"))
        described_class.public_send(level, error)
      end

      it 'calls .report with extra metadata' do
        expect(described_class).to receive(:report).with(level, error, extra: :data)
        expect(described_class).to receive(:log).with(level, error)
        described_class.public_send(level, error, extra: :data)
      end
    end
  end

  shared_examples_for 'critical log levels' do |level|
    describe ".#{level}" do
      it 'Logs to logger' do
        expect(described_class.logger).to receive(:fatal).with(error.inspect)
        expect(described_class.logger).to receive(:fatal).with(error.backtrace.join("\n"))
        described_class.public_send(level, error)
      end

      it 'calls .report with extra metadata' do
        expect(described_class).to receive(:report).with(:critical, error, extra: :data)
        expect(described_class).to receive(:log).with(:fatal, error)
        described_class.public_send(level, error, extra: :data)
      end
    end
  end

  it_should_behave_like 'critical log levels', :critical
  it_should_behave_like 'critical log levels', :fatal
  it_should_behave_like 'log levels', :error
  it_should_behave_like 'log levels', :warn
  it_should_behave_like 'log levels', :info
  it_should_behave_like 'log levels', :debug

  describe '.log' do
    it 'logs to Logger' do
      expect(described_class.logger).to receive(:error).with(error.inspect)
      expect(described_class.logger).to receive(:error).with(error.backtrace.join("\n"))
      described_class.error(error)
    end
  end

  describe '.report' do
    it 'reports to available reporters' do
      stub_const 'Rollbar', reporter_class

      allow(described_class.logger).to receive(:error)
      described_class.reporters = [Rollbar]
      expect(Rollbar).to receive(:error).with(error)
      described_class.error(error)
    end

    it 'handles extra metadata while reporting' do
      stub_const 'Ralebar', reporter_class
      stub_const 'Rolibar', extra_data_reporter_class

      described_class.reporters = [Rolibar, Ralebar]
      allow(described_class.logger).to receive(:error)
      expect(Rolibar).to receive(:error).with(error, extra: :data)
      described_class.error(error, extra: :data)
    end
  end

  describe 'logger' do
    it 'returns default logger if not set' do
      expect(described_class.logger).to be_a(Logger)
    end

    it 'allows to set logger' do
      stub_const 'StubbedLogger', Class.new
      expect(described_class.logger).to be_a(Logger)
      described_class.logger = StubbedLogger.new
      expect(described_class.logger).to be_a(StubbedLogger)
    end
  end

  describe 'reporters' do
    it 'returns default reporters if not set' do
      expect(described_class.reporters).to eq([])
    end

    it 'allows to set reporters' do
      stub_const 'Rollbar', reporter_class

      expect(described_class.reporters).to eq([])
      described_class.reporters = [Rollbar]
      expect(described_class.reporters).to eq([Rollbar])
    end
  end
end
# rubocop:enable Metrics/BlockLength
