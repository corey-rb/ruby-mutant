require "mutant"
require "mutant_spec_helper"

RSpec.configure do |c|
  c.include MutantHelpers
end

RSpec.describe Mutant do
  before do
    
  end

  describe "core gem" do
    it "has a version number" do
      expect(Mutant::VERSION).not_to be nil
    end
  end

  describe "An empty mutation" do
    let(:output) { MutantHelpers::RecipeCreatedEmptyMutation.run() }

    context "can still execute with no data" do
      it "should pass successfully with no data and return an output object" do
        expect(output).to_not be_nil
        expect(output.success?).to eq(true)
      end
    end
  end

  describe "a mutation" do
    context "with raise_on_error=true" do
      it "should throws error if raise_on_error is true, or not set" do
        expect { raise MutantHelpers::RecipeInvalidMutation.run(raise_on_error: true) }.to raise_error(MutationSetupException)
      end
    end
  end

  describe "A mutatation with raise_on_error=false" do
    let(:output) {MutantHelpers::RecipeCreatedMutation.run(raise_on_error: false) }

    context "is a valid mutation -" do
      it "should set the values of the class mutation based on the props supplied to run()" do
        expect(output).to_not be_nil
        expect(output.meta).to_not be_nil
        expect(output.meta[:test]).to eq 'value'
      end

      it "should create accessors for properties defined in run() that are missing on class definition" do
      end

      it "should not throw error if raise_on_error is false" do
        expect { raise MutantHelpers::RecipeInvalidMutation.run(raise_on_error: false) }.to_not raise_error(MutationSetupException)
      end

      it "should execute validators and ensure they all return truthy" do
        expect(output.errors.length).to eq 0
      end
    end

    context "an invalid mutation" do
      it "should raise an error if execute is missing" do
        expect { raise MutantHelpers::RecipeBrokenMutation.run() }.to raise_error(MutationSetupException)
      end

      it "should fail if not all required properties are present" do
        #expect { raise ProductCreatedMutation.run() }.to raise_error(MutationPropUndefined)
      end
    end
  end

  describe "A mutation with input parameters" do
    let(:output) { MutantHelpers::RecipeCreatedMutation.run(name: 'Corey', skill_level: 100) }
  end

  # it "should pass if all required properties are present" do
  #   output = ProductCreatedMutation.run(name: 'Beer Bottle', code: '02AM4D', number: 1)
  #   expect(output).to_not be_nil
  #   expect(output.success?).to eq(true)
  #   expect(output.payload).to eq('Beer Bottle.02AM4D')
  # end

  # it "should validate that all properties are of the correct type" do
  #   expect { raise ProductCreatedMutation.run(name: 'Beer Bottle', code: '02AM4D', number: 'AA') }.to raise_error(MutationValidationException)
  # end


end
