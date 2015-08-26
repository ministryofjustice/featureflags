require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'featureflags/features'

describe "Featureflags" do
  let(:args){ 
    {
      cheese: 'gruyere',
      facebook_login: true,
      facebook_autopost: false
    }
  }
  before do
    FeatureFlags::Features.init!( args )
  end

  describe 'init!' do
    context 'given no args' do
      let(:args){ nil }

      it 'creates an empty set of flags' do
        expect(FeatureFlags::Features.all_defaults).to eq({})
      end
    end

    context 'given args' do
      let(:args){ {'facebook.authentication' => true, 'facebook.autopost' => false} }

      it "stores the given args as flags" do
        expect(FeatureFlags::Features.all_defaults).to eq(args)
      end
    end
  end

  describe 'enabled?' do
    describe 'the given name' do
      context 'is a sym' do
        let(:name){ :facebook_login }

        it 'resolves correctly' do
          expect(FeatureFlags::Features.enabled?(name)).to eq(true)
        end
      end

      context 'is a string' do
        let(:name){ 'facebook_login' }

        it 'resolves correctly' do
          expect(FeatureFlags::Features.enabled?(name)).to eq(true)
        end
      end

      context 'has a non-boolean value' do
        let(:name){ 'cheese' }

        it 'returns true' do
          expect(FeatureFlags::Features.enabled?(name)).to eq(true)
        end
      end

      context 'does not exist' do
        let(:name){ 'foo' }

        it 'returns false' do
          expect(FeatureFlags::Features.enabled?(name)).to eq(false)
        end
      end
    end
  end

  describe 'flag' do
    context 'when an ENV var exists with the corresponding name' do
      before do
        allow(ENV).to receive(:[]).with('FACEBOOK_AUTOPOST').and_return('oh-yes-indeed')
      end

      it 'returns the ENV var value' do
        expect(FeatureFlags::Features.flag('facebook_autopost')).to eq('oh-yes-indeed')
      end
    end
    context 'when an ENV var with the corresponding name does not exist' do
      before do
        allow(ENV).to receive(:[]).with('FACEBOOK_AUTOPOST').and_return(nil)
      end

      it 'returns the inital value' do
        expect(FeatureFlags::Features.flag('facebook_autopost')).to eq(false)
      end
    end
  end

  describe 'all_defaults' do
    it 'returns all the stored flags' do
      expect(FeatureFlags::Features.all_defaults).to eq(args)
    end
  end

  describe 'enabled_by_default' do
    it 'returns all stored flag keys with a not-false stored value' do
      expect(FeatureFlags::Features.enabled_by_default).to eq([:cheese, :facebook_login])
    end
  end

  describe 'any_enabled?' do
    context 'when at least one of the given keys is currently enabled' do
      let(:keys){ [:cheese, :facebook_autopost] }

      it 'returns true' do
        expect(FeatureFlags::Features.any_enabled?(keys)).to eq(true)
      end
    end

    context 'when none of the given keys are currently enabled' do
      let(:keys){ [:donkeys, :facebook_autopost] }

      it 'returns false' do
        expect(FeatureFlags::Features.any_enabled?(keys)).to eq(false)
      end
    end
  end

  describe 'all_enabled?' do
    context 'when all of the given keys are currently enabled' do
      let(:keys){ [:cheese, :facebook_login] }

      it 'returns true' do
        expect(FeatureFlags::Features.all_enabled?(keys)).to eq(true)
      end
    end

    context 'when any of the given keys are not currently enabled' do
      let(:keys){ [:donkeys, :facebook_autopost] }

      it 'returns false' do
        expect(FeatureFlags::Features.all_enabled?(keys)).to eq(false)
      end
    end
  end

  describe 'env_ize' do
    describe 'a sequence of punctation characters other than _' do
      it 'gets replaced with _' do
        expect(FeatureFlags::Features.env_ize('SOME_THING-THAT.IS...ENABLED!')).to eq('SOME_THING_THAT_IS_ENABLED_')
      end
    end

    describe 'a sequence of ascii characters other than A-Z or 0-9' do
      it 'gets replaced with _' do
        expect(FeatureFlags::Features.env_ize('is it red???')).to eq('IS_IT_RED_')
      end
    end

    describe 'a sequence of non-ascii characters' do
      it 'gets replaced with _' do
        expect(FeatureFlags::Features.env_ize('ಠ益ಠRAGEಠ益ಠ')).to eq('_RAGE_')
      end
    end

    describe 'a sequence of lower-case ASCII characters' do
      it 'gets upper-cased' do
        expect(FeatureFlags::Features.env_ize('ascii')).to eq('ASCII')
      end
    end
  end
end
