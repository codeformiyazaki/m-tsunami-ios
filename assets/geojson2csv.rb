# Swiftでのjsonの扱いがあまりにも面倒だったので、ここで再びcsvに戻す..

require 'json'
require 'csv'

# 以下からダウンロードしたgeojsonを使います
# https://github.com/code4miyazaki/geojson/blob/master/hinanzyo.geojson
json = JSON.parse(File.read("hinanzyo.geojson"))

# shelters
fh = File.open("../iosapp/06-earthquake/shelters.csv","w")
fh.write("施設種別,建物名,住所,想定収容人数,MHトイレ基数,lng,lat\n")
json["features"].each do |feature|
  ps = feature["properties"]
  # 地震・津波対応でない避難所はスキップ
  next if ps["災害種別＝\n 地震"] != "1" and ps["災害種別＝\n 津波"] != "1"
  row =  [ps["施設種別\n 呼称"]]
  row += [ps["name"],ps["住所"],ps["想定収容人数"],ps["MHトイレ\n 基数"]]
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
