# frozen_string_literal: true

module Kernel
  def sleep(time); end
end

RSpec.describe Up do
  it 'has a version number' do
    expect(Up::VERSION).not_to be nil
  end

  it 'Can parse uri like https://l3.ai' do
    uri = Up.parse_uri('https://l3.ai')
    expect(uri.hostname).to eq('l3.ai')
    expect(uri.port).to eq(443)
    expect(uri.scheme).to eq('https')
    expect(uri.path).to eq('/')
  end

  it 'Return nil when parsing invalid uri like http//invalid.com' do
    uri = Up.parse_uri('http//invalid.com')
    expect(uri).to eq(nil)
  end

  it 'Can fetch uri' do
    stub_request(:any, 'https://l3.ai')
    Up.fetch(Up.parse_uri('https://l3.ai'))
    expect(WebMock).to have_requested(:get, 'https://l3.ai')
  end

  it 'Should ping uri' do
    stub_request(:any, 'https://l3.ai')
    Up.run('https://l3.ai')
    expect(WebMock).to have_requested(:get, 'https://l3.ai').times(6)
  end
end
