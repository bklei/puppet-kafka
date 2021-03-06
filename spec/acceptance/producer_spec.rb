require 'spec_helper_acceptance'

describe 'kafka::producer' do
  it 'should work with no errors' do
    pp = <<-EOS
      class { 'zookeeper': } ->
      class { 'kafka::producer':
        service_config => {
          'broker-list' => 'localhost:9092',
          topic         => 'demo',
        },
      }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end

  describe 'kafka::producer::install' do
    context 'with default parameters' do
      it 'should work with no errors' do
        pp = <<-EOS
          class { 'zookeeper': } ->
          class { 'kafka::producer':
            service_config => {
              'broker-list' => 'localhost:9092',
              topic         => 'demo',
            },
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe group('kafka') do
        it { is_expected.to exist }
      end

      describe user('kafka') do
        it { is_expected.to exist }
        it { is_expected.to belong_to_group 'kafka' }
        it { is_expected.to have_login_shell '/bin/bash' }
      end

      describe file('/var/tmp/kafka') do
        it { is_expected.to be_directory }
        it { is_expected.to be_owned_by 'kafka' }
        it { is_expected.to be_grouped_into 'kafka' }
      end

      describe file('/opt/kafka-2.11-0.9.0.1') do
        it { is_expected.to be_directory }
        it { is_expected.to be_owned_by 'kafka' }
        it { is_expected.to be_grouped_into 'kafka' }
      end

      describe file('/opt/kafka') do
        it { is_expected.to be_linked_to('/opt/kafka-2.11-0.9.0.1') }
      end

      describe file('/opt/kafka/config') do
        it { is_expected.to be_directory }
        it { is_expected.to be_owned_by 'kafka' }
        it { is_expected.to be_grouped_into 'kafka' }
      end

      describe file('/var/log/kafka') do
        it { is_expected.to be_directory }
        it { is_expected.to be_owned_by 'kafka' }
        it { is_expected.to be_grouped_into 'kafka' }
      end
    end
  end

  describe 'kafka::producer::config' do
    context 'with default parameters' do
      it 'should work with no errors' do
        pp = <<-EOS
          class { 'zookeeper': } ->
          class { 'kafka::producer':
            service_config => {
              'broker-list' => 'localhost:9092',
              topic         => 'demo',
            },
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe file('/opt/kafka/config/producer.properties') do
        it { is_expected.to be_file }
        it { is_expected.to be_owned_by 'kafka' }
        it { is_expected.to be_grouped_into 'kafka' }
      end
    end
  end

  describe 'kafka::producer::service' do
    context 'with default parameters' do
      it 'should work with no errors' do
        pp = <<-EOS
          class { 'zookeeper': } ->
          class { 'kafka::producer':
            service_config => {
              'broker-list' => 'localhost:9092',
              topic         => 'demo',
            },
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe file('/etc/init.d/kafka-producer') do
        it { is_expected.to be_file }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
      end

      describe service('kafka-producer') do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end
    end
  end
end
