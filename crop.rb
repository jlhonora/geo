#!/usr/bin/env ruby

require 'json'

f = File.read('all.geojson')

def crop_feature(bounds, array)
  if array[0].is_a? Array and array[0][0].is_a? Float
    array.delete_if { |x| (x[0] < bounds[0][0]) or (x[0] > bounds[1][0]) or (x[1] < bounds[0][1]) or (x[1] > bounds[1][1]) }
  else
    array = array.each do |sub_array|
      crop_feature(bounds, sub_array)
    end
  end

  return array
end

data = JSON.parse(f)
#         min     max
#      long, lat
bounds = [[-78, -55.98], [-66.4182, -17.4982]]
data["features"] = data["features"].each do |feature_all|
  this_feature = crop_feature(bounds, feature_all["geometry"]["coordinates"])
  p feature_all["properties"]
  feature_all["geometry"]["coordinates"] = this_feature
end

f2 = File.open('all2.geojson', 'w')
f2.write(data.to_json)
