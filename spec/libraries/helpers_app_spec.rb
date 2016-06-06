require_relative '../spec_helper'
require_relative '../../libraries/helpers_app'

describe ReattachToUserNamespace::Helpers::App do
  describe '.installed_version?' do
    let(:installed) { nil }
    let(:installed_version) { nil }

    before(:each) do
      allow(described_class).to receive(:installed?).and_return(installed)
      allow(described_class).to receive(:shell_out)
        .with('reattach-to-user-namespace -v')
        .and_return(double(stdout: "Rtun v #{installed_version}\nStuff\n"))
    end

    context 'installed' do
      let(:installed) { true }
      let(:installed_version) { '1.2.3' }

      it 'returns the installed version' do
        expect(described_class.installed_version?).to eq('1.2.3')
      end
    end

    context 'not installed' do
      let(:installed) { false }

      it 'returns nil' do
        expect(described_class.installed_version?).to eq(nil)
      end
    end
  end

  describe '.installed?' do
    let(:installed) { nil }

    before(:each) do
      allow(File).to receive(:exist?)
        .with('/usr/local/bin/reattach-to-user-namespace')
        .and_return(installed)
    end

    context 'installed' do
      let(:installed) { true }

      it 'returns true' do
        expect(described_class.installed?).to eq(true)
      end
    end

    context 'not installed' do
      let(:installed) { false }

      it 'returns false' do
        expect(described_class.installed?).to eq(false)
      end
    end
  end

  describe '.latest_version?' do
    before(:each) do
      uri = URI('https://api.github.com/repos/ChrisJohnsen/' \
                'tmux-MacOSX-pasteboard/releases')
      allow(Net::HTTP).to receive(:get).with(uri)
        .and_return('[{"tag_name": "v1.2.3"}, {"tag_name": "v1.1.0"}]')
    end

    it 'returns the latest tagged version' do
      expect(described_class.latest_version?).to eq('1.2.3')
    end
  end
end
