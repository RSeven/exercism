=begin
Write your code for the 'Knapsack' exercise in this file. Make the tests in
`knapsack_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/knapsack` directory.
=end
class Knapsack
  def initialize(max_weight)
    @max_weight = max_weight
  end

  def max_value(items)
    return 0 if items.empty?
    
    # max_value_table[max_weight][item] = maximum value possible including "item" with "max_weight"
    max_value_table = Array.new(items.size + 1) { Array.new(@max_weight + 1, 0) }

    
    items.each_with_index do |item, idx|
      (0..@max_weight).each do |target_weight|
        item_id = idx + 1

        max_without_item = max_value_table[item_id-1][target_weight]
        max_with_item = target_weight >= item.weight ? (max_value_table[item_id - 1][target_weight - item.weight] + item.value) : max_without_item
        
        max_value_table[item_id][target_weight] = [max_without_item, max_with_item].max
      end
    end

    debug "#{items.size} #{@max_weight} \n#{max_value_table.map(&:inspect).join("\n")}"

    max_value_table[items.size][@max_weight]
  end
end