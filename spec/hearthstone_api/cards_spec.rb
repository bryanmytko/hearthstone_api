require "spec_helper"

describe HearthstoneApi::Cards do
  let(:cards) { described_class }

  describe "all cards" do
    let(:option) { "attack" }

    it "returns cards" do
      VCR.use_cassette("hearthstone_api/cards") do
        expect(cards.all).to_not be_empty
      end
    end

    it "accepts options" do
      VCR.use_cassette("hearthstone_api/cards/options") do
        query = cards.all(option => 1)
        option_values = query[query.keys.first].collect{ |c| c[option] }.uniq
        expect(option_values).to eq([1])
      end
    end
  end

  describe "class cards" do
    let(:klass) { "Paladin" }
    let(:option) { "cost" }

    it "returns class cards" do
      VCR.use_cassette("hearthstone_api/cards/classes") do
        query = cards.classes(klass, option => 1)
        class_values = query.collect{ |c| c["playerClass"] }.uniq
        expect(class_values).to eq([klass])
      end
    end

    it "accepts options" do
      VCR.use_cassette("hearthstone_api/cards/classes/options") do
        query = cards.classes(klass, option => 1)
        option_values = query.collect { |c| c[option] }.uniq
        expect(option_values).to eq([1])
      end
    end
  end

  describe "single card" do
    context "when finding by id" do
      let(:id) { "EX1_572" }
      let(:locale) { "jaJP" }

      it "returns the card" do
        VCR.use_cassette("hearthstone_api/cards/single/id") do
          query = cards.single(id)
          expect(query.first["cardId"]).to eq(id)
        end
      end

      it "accepts options" do
        VCR.use_cassette("hearthstone_api/cards/single/id/options") do
          query = cards.single(id, locale: locale)
          expect(query.first["locale"]).to eq(locale)
        end
      end
    end

    context "when finding by name" do
      let(:name) { "Ysera" }
      let(:locale) { "jaJP" }
      let(:locale_name) { "イセラ" }

      it "returns the card" do
        VCR.use_cassette("hearthstone_api/cards/single/name") do
          query = cards.single(name)
          expect(query.first["name"]).to eq(name)
        end
      end

      it "accepts options" do
        VCR.use_cassette("hearthstone_api/cards/single/id/options") do
          query = cards.single(name, locale: locale)
          expect(query.first["name"]).to eq(locale_name)
        end
      end
    end
  end

  describe "type of card" do
    let(:type) { "Weapon" }
    let(:locale) { "jaJP" }

    it "returns cards by type" do
      VCR.use_cassette("hearthstone_api/cards/type") do
        query = cards.type(type, locale: locale)
        expect(query.first["type"]).to eq(type)
      end
    end

    it "accepts options" do
      VCR.use_cassette("hearthstone_api/cards/type/options") do
        query = cards.type(type, locale: locale)
        expect(query.first["locale"]).to eq(locale)
      end
    end
  end

  describe "cards by set" do
    let(:set) { "Classic" }
    let(:locale) { "jaJP" }

    it "returns cards by set" do
      VCR.use_cassette("hearthstone_api/cards/sets") do
        query = cards.sets(set, locale: locale)
        expect(query.first["cardSet"]).to eq(set)
      end
    end

    it "accepts options" do
      VCR.use_cassette("hearthstone_api/cards/sets/options") do
        query = cards.sets(set, locale: locale)
        expect(query.first["locale"]).to eq(locale)
      end
    end
  end

  describe "cards by race" do
    let(:race) { "Murloc" }
    let(:locale) { "jaJP" }

    it "returns cards by race" do
      VCR.use_cassette("hearthstone_api/cards/races") do
        query = cards.races(race, locale: locale)
        expect(query.first["race"]).to eq(race)
      end
    end

    it "accepts options" do
      VCR.use_cassette("hearthstone_api/cards/races/options") do
        query = cards.races(race, locale: locale)
        expect(query.first["locale"]).to eq(locale)
      end
    end
  end

  describe "cards by quality" do
    let(:quality) { "Legendary" }
    let(:locale) { "jaJP" }

    it "returns cards by quality" do
      VCR.use_cassette("hearthstone_api/cards/quality") do
        query = cards.qualities(quality, locale: locale)
        expect(query.first["rarity"]).to eq(quality)
      end
    end

    it "accepts options" do
      VCR.use_cassette("hearthstone_api/cards/quality/options") do
        query = cards.qualities(quality, locale: locale)
        expect(query.first["locale"]).to eq(locale)
      end
    end
  end

  describe "cards by faction" do
    let(:faction) { "Horde" }
    let(:locale) { "jaJP" }

    it "returns cards by faction" do
      VCR.use_cassette("hearthstone_api/cards/faction") do
        query = cards.factions(faction)
        expect(query.first["faction"]).to eq(faction)
      end
    end

    it "accepts options" do
      VCR.use_cassette("hearthstone_api/cards/faction/options") do
        query = cards.factions(faction, locale: locale)
        expect(query.first["locale"]).to eq(locale)
      end
    end
  end

  describe "search" do
    let(:search_term) { "Ysera" }
    let(:locale_search_term) { "イセラ" }
    let(:locale) { "jaJP" }

    it "returns cards by partial search" do
      VCR.use_cassette("hearthstone_api/cards/search") do
        query = cards.search(search_term.slice(0...4))
        expect(query.first["name"]).to include(search_term)
      end
    end

    it "accepts options" do
      VCR.use_cassette("hearthstone_api/cards/search/options") do
        query = cards.search(locale_search_term, locale: locale)
        expect(query.first["locale"]).to eq(locale)
      end
    end

    it "searches other languages in that language" do
      VCR.use_cassette("hearthstone_api/cards/search/locale") do
        query = cards.search(locale_search_term, locale: locale)
        expect(query.first["name"]).to include(locale_search_term)
        expect(query.first["name"]).to_not include(search_term)
      end
    end
  end
end
