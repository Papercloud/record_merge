require 'spec_helper'

describe TestModel do
  before :each do

    Relation1.class_eval do
      belongs_to :test_model
    end

    Relation2.class_eval do
      has_many :test_models
    end
  end

  it "has valid factory" do
    model = build(:test_model)
    expect(model).to be_valid
  end

  describe "RecordMerge.record_merge" do

    it "cant override destination objects id" do
      source = create(:test_model, name: "Malcolm", email: "malcolm@aol.com")
      destination = create(:test_model, name: "James", email: "james@aol.com")
      expect{
        RecordMerge.merge(destination, source, attributes: [:id])
        destination.reload
      }.to_not change(destination, :id)
    end

    it "only transfers specified attributes" do
      source = create(:test_model, name: "Malcolm", email: "malcolm@aol.com")
      destination = create(:test_model, name: "James", email: "james@aol.com")

      RecordMerge.merge(destination, source, attributes: [:name])
      destination.reload

      expect(destination.name).to eq "Malcolm"
      expect(destination.email).to eq "james@aol.com"
    end

    it "deletes source record" do
      source = create(:test_model, name: "Malcolm", email: "malcolm@aol.com")
      destination = create(:test_model, name: "James", email: "james@aol.com")
      expect{
        RecordMerge.merge(destination, source)
      }.to change(TestModel, :count).by(-1)
    end

    context :has_one do
      before :each do
        TestModel.class_eval do
          has_one :relation1
        end
      end

      it "associates source relation with destination" do
        source = create(:test_model, name: "Malcolm", email: "malcolm@aol.com")
        relation = create(:relation1, test_model: source)
        destination = create(:test_model, name: "James", email: "james@aol.com")

        expect{
          RecordMerge.merge(destination, source, copy_relations: true)
          destination.reload
        }.to change(destination, :relation1).to relation
      end
    end

    context :has_many do
      before :each do
        TestModel.class_eval do
          has_many :relation1s
        end
      end

      it "associates source relation with destination" do
        source = create(:test_model, name: "Malcolm", email: "malcolm@aol.com")
        relation = create(:relation1, test_model: source)
        destination = create(:test_model, name: "James", email: "james@aol.com")

        expect{
          RecordMerge.merge(destination, source, copy_relations: true)
          destination.reload
        }.to change(destination.relation1s, :count).by(1)
      end
    end

    context :belongs_to do
      before :each do
        TestModel.class_eval do
          belongs_to :relation2
        end
      end

      it "associations source relation with destination" do
        source = create(:test_model, name: "Malcolm", email: "malcolm@aol.com", relation2: create(:relation2))
        destination = create(:test_model, name: "James", email: "james@aol.com")
        expect{
          RecordMerge.merge(destination, source, copy_relations: true)
          destination.reload
        }.to change(destination, :relation2).to source.relation2
      end
    end
  end


end
