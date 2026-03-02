Item = Struct.new(:name, :sell_in, :quality)

class GildedRose
  def initialize(items)
    @items = items
  end

  def update!
    @items.each do |item|
      item.quality = [item.quality, 0].max

      conjured = (item.name =~ /Conjured/i)
      
      case item.name
        when /Sulfuras, Hand of Ragnaros/i
          handle_sulfuras_update(item, conjured)
        when /Aged Brie/i
          handle_aged_brie_update(item, conjured)
        when /Backstage passes/i
          handle_backstage_passes_update(item, conjured)
        else
          handle_common_item_update(item, conjured)
      end
    end
  end

private
  def handle_sulfuras_update(item, conjured)
    return unless conjured

    item.quality = 0 if item.sell_in <= 0
    item.sell_in -= 1
  end
  
  def handle_common_item_update(item, conjured)
    if conjured && item.sell_in <= 0
      item.quality = 0
    else
      quality_change = conjured ? 2 : 1
      
      item.quality -= quality_change
      item.quality -= quality_change if item.sell_in <= 0
    end

    item.quality = [item.quality, 0].max
    item.sell_in -= 1
  end
  
  def handle_aged_brie_update(item, conjured)
    if conjured && item.sell_in <= 0
      item.quality = 0
    else
      item.quality += 1
      item.quality += 1 if item.sell_in <= 0
    end
    
    item.quality = [item.quality, 50].min
    item.sell_in -= 1
  end

  def handle_backstage_passes_update(item, conjured)
    conjured_change = conjured ? -1 : 0

    case item.sell_in
      when ..0
        item.quality = 0
      when 1..5
        item.quality += 3 + conjured_change
      when 6..10
        item.quality += 2 + conjured_change
      else
        item.quality += 1 + conjured_change
    end

    item.sell_in -= 1
    item.quality = [item.quality, 50].min
  end
end
