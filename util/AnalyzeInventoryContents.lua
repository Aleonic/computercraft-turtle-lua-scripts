local inv = peripheral.wrap("front")
for slot, item in pairs(inv.list()) do
  print(("%d x %s in slot %d"):format(item.count, item.name, slot))
end