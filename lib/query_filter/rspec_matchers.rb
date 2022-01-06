# frozen_string_literal: true

RSpec.configure do |config|
  module QueryFilter::RSpecMatchers
    extend RSpec::Matchers::DSL

    def relation(override = nil)
      @relation ||= override || double('ActiveRecord::Relation')
    end

    def filter(params)
      described_class.new(relation, params).to_query
    end

    # Usage:
    #
    # expect { filter(username: "joe") }.to perform_query(users: { username: "joe" })
    # expect { filter(field: :invalid_value) }.to_not perform_query
    #
    matcher :perform_query do |*params_for_where|
      def supports_block_expectations?
        true
      end

      match do |block|
        expect(relation).to receive(:where).with(*params_for_where)
        block.call
      end

      match_when_negated do |block|
        expect(relation).to_not receive(:where)
        block.call
      end
    end

    # Usage:
    #
    # expect { filter(sort: :asc) }.to reorder.by("users.created_at" => "asc")
    # expect { filter(sort: :invalid_value) }.to_not reorder
    #
    matcher :reorder do
      def supports_block_expectations?
        true
      end

      match do |block|
        expect(relation).to receive(:reorder).with(@params_for_reorder)
        block.call
      end

      match_when_negated do |block|
        expect(relation).to_not receive(:reorder)
        block.call
      end

      chain :by do |conditions|
        @params_for_reorder = conditions
      end
    end
  end

  config.after do
    @relation = nil
  end
end
