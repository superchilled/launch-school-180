require "sequel"

HOURLY_RATE = 12

DB = Sequel.connect("postgres://karl:nikita@localhost/sequel-single-table")

def monetary(price)
  sprintf("%.2f", price)
end

def item_string(item)
  labor = (item[:prep_time] / 60.0) * HOURLY_RATE
  profit = item[:menu_price] - (item[:ingredient_cost] + labor)

  "#{item[:item]}\n" +
  "menu price: $#{monetary(item[:menu_price])}\n" +
  "ingredient cost: $#{monetary(item[:ingredient_cost])}\n" +
  "labor: $#{monetary(labor)}\n" +
  "profit: $#{monetary(profit)}\n\n"
end

menu_items = DB[:menu_items].select do
  [item, menu_price.cast(:float), ingredient_cost.cast(:float), prep_time]
end

menu_items.each do |item|
  puts item_string(item)
end