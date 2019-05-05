import pandas as pd
import googlemaps, os

# Google Cloud Console でキーを取得する必要があります
gmaps = googlemaps.Client(key=os.environ['GOOGLE_APIKEY'])

# 入力：津波避難ビル一覧(tsv形式) buildings.tsv
# https://docs.google.com/spreadsheets/d/1FdGLrjkuGBtYe4DSTrTFV861ukzReuXsBDEJsw8oS1M/edit?usp=sharing
# 出力：buildings_locations.csv lat,lng列が追加されたCSV

# Geocoding an address
def latlng(address):
    r = gmaps.geocode('宮崎市'+address)
    loc = r[0]['geometry']['location'] # lat:31.1234,lng:131.1234
    return loc['lat'],loc['lng']

df = pd.read_csv('buildings.tsv',delimiter='\t')
for row in df.iterrows():
    lat, lng = latlng(row[1]['住所'])
    df.at[row[0],'lat'] = lat
    df.at[row[0],'lng'] = lng

df.to_csv('buildings_locations.csv')
