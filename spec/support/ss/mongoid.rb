# mongoid
shared_examples "mongoid#save" do
  it { expect { build(factory).save! }.not_to raise_error }
end

shared_examples "mongoid#find" do
  it { expect(model.first).not_to eq nil }
  #it { expect(model.all.size).not_to eq 0 }
end

module Mongoid
  module Tasks
    module Database
      private
        # rewrite logger method.
        def self.logger
          Rails.logger
        end
    end
  end
end
