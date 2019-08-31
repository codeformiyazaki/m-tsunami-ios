# 19.08.31
# csv->jsonへのデータ形式変更に伴って一回だけ使用した変換ツールです。

require 'json'
require 'csv'

features = []

# buildings
data = CSV.read("buildings_locations.csv", headers: true, encoding: "utf-8")
p data.headers # ,建物名,住所,標高,構造,階数,lat,lng
features = []
data.each do |row|
  lat = row[6].to_f
  lng = row[7].to_f
  features += [{ "type": "Feature", "properties": { "建物名": row[1], "住所": row[2], "標高": row[3], "構造": row[4], "階数": row[5]  }, "geometry": { "type": "Point", "coordinates": [ lng, lat ] }}]
end
buildings = {name: "buildings",type: "FeatureCollection",features:features}

fh = File.open("../iosapp/06-earthquake/geojson/buildings.geojson","w")
fh.write(JSON.pretty_generate(buildings))
fh.close


# toilets
data = CSV.read("toilets_locations.csv", headers: true, encoding: "utf-8")
p data.headers # 施設名,数,lat,lng
features = []
data.each do |row|
  lat = row[2].to_f
  lng = row[3].to_f
  features += [{ "type": "Feature", "properties": { "施設名": row[0], "数": row[1].to_i}, "geometry": { "type": "Point", "coordinates": [ lng, lat ] }}]
end
toilets = {name: "toilets",type: "FeatureCollection",features:features}

fh = File.open("../iosapp/06-earthquake/geojson/toilets.geojson","w")
fh.write(JSON.pretty_generate(toilets))
fh.close

# webcams
data = CSV.read("webcams_locations.csv", headers: true, encoding: "utf-8")
p data.headers # 設置場所,url,lat,lng
features = []
data.each do |row|
  lat = row[2].to_f
  lng = row[3].to_f
  features += [{ "type": "Feature", "properties": { "設置場所": row[0], "URL": row[1]}, "geometry": { "type": "Point", "coordinates": [ lng, lat ] }}]
end
webcams = {name: "webcams",type: "FeatureCollection",features:features}

fh = File.open("../iosapp/06-earthquake/geojson/webcams.geojson","w")
fh.write(JSON.pretty_generate(webcams))
fh.close
