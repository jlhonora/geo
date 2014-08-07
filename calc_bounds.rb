#!/usr/bin/env ruby

require 'json'

f = File.read('all.geojson')

def update_bounds(bounds, candidate)
  bounds[0][0] = candidate[0][0] if candidate[0][0] < bounds[0][0]
  bounds[0][1] = candidate[0][1] if candidate[0][1] < bounds[0][1]
  bounds[1][1] = candidate[1][1] if candidate[1][1] > bounds[1][1]
  bounds[1][0] = candidate[1][0] if candidate[1][0] > bounds[1][0]
  return bounds
end

def get_bounds(array)
  bounds = [[Float::INFINITY,Float::INFINITY], [-Float::INFINITY,-Float::INFINITY]]
  if array[0].is_a? Float
    return update_bounds(bounds, [array, array])
  else
    array.each do |sub_array|
      bounds = update_bounds(bounds, get_bounds(sub_array))
    end
    return bounds
  end

end

data = JSON.parse(f)
#         min     max
#      long, lat
bounds = [[Float::INFINITY,Float::INFINITY], [-Float::INFINITY,-Float::INFINITY]]
data["features"].each do |feature_all|
  this_bounds = get_bounds(feature_all["geometry"]["coordinates"])
  p feature_all["properties"]
  p this_bounds
  update_bounds(bounds, this_bounds)
end

p bounds
