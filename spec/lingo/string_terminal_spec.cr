require "../spec_helper"

def alpha_rule
  Lingo::StringTerminal.new("alpha")
end

def beta_rule
  Lingo::StringTerminal.new("beta")
end

def gamma_rule
  Lingo::StringTerminal.new("gamma")
end

describe "Lingo::StringTerminal" do
  describe "string rules" do
    describe "#parse" do
      it "returns a node" do
        rule = alpha_rule
        result = rule.parse("alpha")
        result.value.should eq("alpha")

        fail_result = rule.parse?("google")
        fail_result.should eq(false)
      end
    end
  end

  describe "#|" do
    it "creates an ordered choice" do
      alphabeta_rule = alpha_rule | beta_rule
      alphabeta_rule.matches?("alpha").should eq(true)
      alphabeta_rule.matches?("beta").should eq(true)
    end
  end

  describe "#>>" do
    it "creates a sequence" do
      alphabeta_rule = alpha_rule >> beta_rule
      alphabeta_rule.matches?("alpha").should eq(false)
      alphabeta_rule.matches?("beta").should eq(false)
      alphabeta_rule.matches?("alphabeta").should eq(true)
      alphabetagamma_rule = alphabeta_rule >> gamma_rule
      alphabetagamma_rule.matches?("alphabetagamma").should eq(true)
    end
  end

  describe "#maybe" do
    it "creates an repeat(0,1)" do
      maybe_alpha_rule = alpha_rule.maybe
      maybe_alpha_rule.matches?("alpha").should eq(true)
      maybe_alpha_rule.matches?("beta").should eq(true)
    end
  end

  describe "#absent" do
    it "creates a NotRule" do
      not_alpha_rule = alpha_rule.absent
      not_alpha_rule.matches?("alpha").should eq(false)
      not_alpha_rule.matches?("beta").should eq(true)
    end
  end
end
