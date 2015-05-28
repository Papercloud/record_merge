require 'spec_helper'

describe TestModel do
  before :each do
    TestModel.class_eval do
      has_many :relation1s
      belongs_to :relation2
    end
  end

  it "has valid factory" do
    model = build(:test_model)
    expect(model).to be_valid
  end

  describe "RecordMerge.record_merge" do
    it "only transfers specified attributes" do
      source = create(:test_model, name: "Malcolm", email: "malcolm@aol.com")
      destination = create(:test_model, name: "James", email: "james@aol.com")
      new_record = RecordMerge.merge(destination, source, [:name])

      expect(new_record.name).to eq "Malcolm"
      expect(new_record.email).to eq "james@aol.com"
    end

    context :has_many do

    end
  end

end
