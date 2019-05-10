# frozen_string_literal: true

module QueryFilter
  module Utils
    class UserConditions
      attr_reader :target

      def initialize(target, options = {})
        @target = target
        @options = options

        @if = Array(options[:if])
        @unless = Array(options[:unless])
      end

      def passed?
        return true if empty?

        value = target.params
        conditions_lambdas.all? { |c| c.call(target, value) }
      end

      def empty?
        @if.empty? && @unless.empty?
      end

      def present?
        !empty?
      end

      def conditions_lambdas
        @if.map { |c| make_lambda c } +
          @unless.map { |c| invert_lambda make_lambda c }
      end

      private

      def invert_lambda(lblock)
        ->(*args, &blk) { !lblock.call(*args, &blk) }
      end

      # Filters support:
      #
      #   Symbols:: A method to call.
      #   Procs::   A proc to call with the object.
      #
      # All of these objects are converted into a lambda and handled
      # the same after this point.
      def make_lambda(filter)
        case filter
        when Symbol
          ->(target, _, &blk) { target.send filter, &blk }
        when ::Proc
          make_proc(filter)
        else
          raise ArgumentError
        end
      end

      def make_proc(filter)
        if filter.arity > 1
          lambda do |target, _, &block|
            raise ArgumentError unless block

            target.instance_exec(target, block, &filter)
          end
        elsif filter.arity <= 0
          ->(target, _) { target.instance_exec(&filter) }
        else
          ->(target, _) { target.instance_exec(target, &filter) }
        end
      end
    end
  end
end
