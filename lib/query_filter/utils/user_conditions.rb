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

      def invert_lambda(l)
        -> (*args, &blk) { !l.call(*args, &blk) }
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
          -> (target, _, &blk) { target.send filter, &blk }
        when ::Proc
          if filter.arity > 1
            return lambda do |target, _, &block|
              raise ArgumentError unless block
              target.instance_exec(target, block, &filter)
            end
          end

          if filter.arity <= 0
            -> (target, _) { target.instance_exec(&filter) }
          else
            -> (target, _) { target.instance_exec(target, &filter) }
          end
        else
          raise ArgumentError
        end
      end
    end
  end
end
