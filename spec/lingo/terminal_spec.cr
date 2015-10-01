require "../spec_helper"

def alpha_rule
  Lingo::Terminal.new("alpha")
end

def beta_rule
  Lingo::Terminal.new("beta")
end

def gamma_rule
  Lingo::Terminal.new("gamma")
end

describe "Lingo::Terminal" do
  describe "string rules" do
    describe "#parse" do
      it "returns a node and the remainder string" do
        rule = alpha_rule
        result = rule.parse("alphabet")
        result.remainder.should eq("bet")
        result.value.should eq("alpha")
        p result

        nil_result = rule.parse?("google")
        nil_result.should eq(nil)
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
end
