# Swiftでのjsonの扱いがあまりにも面倒だったので、ここで再びcsvに戻す..

require 'json'
require 'csv'

# buildings
fh = File.open("../iosapp/06-earthquake/buildings_locations.csv","w")
fh.write("建物名,住所,標高,構造,階数,lng,lat\n")
json = JSON.parse(File.read("buildings.geojson"))
json["features"].each do |feature|
  row = feature["properties"].values
  row += feature["geometry"]["coordinates"]
  fh.write(row.join(",")+"\n")
end
fh.close

# toilets
fh = File.open("../iosapp/06-earthquake/toilets_locations.csv","w")
fh.write("施設名,数,lng,lat\n")
json = JSON.parse(File.read("toilets.geojson"))

json["features"].each do |feature|
  row = feature["properties"].values
  row += feature["geometry"]["coordinates"]
  fh.write(row.join(",")+"\n")
end
fh.close

# webcams
fh = File.open("../iosapp/06-earthquake/webcams_locations.csv","w")
fh.write("設置場所,URL,lng,lat\n")
json = JSON.parse(File.read("webcams.geojson"))

json["features"].each do |feature|
  row = feature["properties"].values
  row += feature["geometry"]["coordinates"]
  fh.write(row.join(",")+"\n")
end
fh.close

# shelters
json = JSON.parse(File.read("shelters.geojson"))
fh = File.open("../iosapp/06-earthquake/shelters_locations.csv","w")
fh.write("建物名,住所,lng,lat\n")
json["features"].each do |feature|
  ps = feature["properties"]
  # 地震・津波対応でない避難所はスキップ
  next if ps["地震"].empty? or ps["津波"].empty?
  row = [ps["指定緊急避難場所"],ps["所在地"]]
  row += feature["geometry"]["coordinates"]
  fh.write(row.join(",")+"\n")
end
fh.close
